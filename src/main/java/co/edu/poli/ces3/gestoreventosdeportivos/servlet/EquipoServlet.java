package co.edu.poli.ces3.gestoreventosdeportivos.servlet;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EquipoResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.JugadorBasico;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.Stack;
import java.util.stream.Collectors;

@WebServlet(name="equipoServlet", value="/equipos")
public class EquipoServlet extends HttpServlet {

    private Stack<EquipoDAO> equipos;
    private Stack<JugadorDAO> jugadores;

    public void init() {
        System.out.println("Init EquipoServlet!!");

        //this.equipos = new Stack<>();
        this.equipos = (Stack<EquipoDAO>) getServletContext().getAttribute("equipos");

        //obtener lista jugadores en el contexto de la app
        this.jugadores = (Stack<JugadorDAO>) getServletContext().getAttribute("jugadores");
        if (this.jugadores == null) {
            this.jugadores = new Stack<>();
        }

//        System.out.println("jugadores: " + jugadores);

//        Stack<Integer> jugadoresEq1 = new Stack<>();
//        jugadoresEq1.push(1);

//        super.init();
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        resp.setContentType("application/json");

//        PrintWriter out = resp.getWriter();

//        Gson gson = new Gson();

        // Devolver equipo con id enviado
        if (req.getParameter("id") != null) {
            try {
                int idEquipo = Integer.parseInt((req.getParameter("id")));
                for (EquipoDAO e : equipos) {
                    if (e.getId() == Math.abs(idEquipo)) {
                        //obtener la lista de jugadores del equipo
                        List<JugadorBasico> jugadoresEquipo = e.getJugadores().stream()
                                .map(idJugador -> jugadores.stream()
                                        .filter(j -> j.getId() == idJugador)
                                        .findFirst()  // Asegurar que obtenemos un único jugador
                                        .orElse(null))  // Si no existe, devolver null
                                .filter(Objects::nonNull)  // eliminar valores  null
                                .map(JugadorBasico::new)  // Convertir a JugadorBasico
                                .collect(Collectors.toList());

                        EquipoResponse equipoResponse = new EquipoResponse(e, jugadoresEquipo);

                        RequestUtils.sendJsonResponse(
                                resp,
                                HttpServletResponse.SC_OK,
                                equipoResponse
                        );
                        return;
                    }
                }
                // si no encontramos el equipo con ese id
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_NOT_FOUND,
                        new ApiResponse("error", "El equipo con id: " + idEquipo + " no existe.")
                );
                return;
            } catch (NumberFormatException ex) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","El id del equipo de ser un numero entero.")
                );
                return;
            }
        }

        // Devoolver todos los equipos con su respectiva paginacion
        //definir parametros de paginación por defecto
//        int page = 1;
//        int size = 1;
        int page = Integer.parseInt(req.getParameter("page"));
        int size = Integer.parseInt(req.getParameter("size"));

        //validar que los parametros lleguen
//        try {
//            if (req.getParameter("page") != null) {
//                page = Integer.parseInt(req.getParameter("page"));
//            }
//            if (req.getParameter("size") != null) {
//                size = Integer.parseInt(req.getParameter("size"));
//            }
//        } catch (NumberFormatException ex) {
////            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//            RequestUtils.sendJsonResponse(
//                    resp,
//                    HttpServletResponse.SC_BAD_REQUEST,
//                    new ApiResponse("error","Los parámetros 'page' y 'size' deben ser números enteros.")
//            );
////            out.println(gson.toJson(new ApiResponse("Los parámetros 'page' y 'size' deben ser números enteros.")));
//            return;
//        }

        //formamtear parametros(solo positivos)
//        page = Math.abs(page);
//        size = Math.abs(size);

        // calclar indices de paginacion
        //int fromIndex = (page - 1) * size;
        //int toIndex = Math.min(fromIndex + size, equipos.size());

        // Calcular los índices de paginación en orden inverso (LIFO)
        int fromIndex = equipos.size() - (page * size);
        int toIndex = fromIndex + size;

        // ajustar indices para evitar errores
        fromIndex = Math.max(fromIndex, 0);
        toIndex = Math.min(toIndex, equipos.size());

        if (fromIndex >= equipos.size() || toIndex <= 0) {
//            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
//            out.println(gson.toJson(new ApiResponse("No hay equipos disponibles.")));
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_NOT_FOUND,
                    new ApiResponse("error","No hay equipos disponibles.")
            );
            return;
        }

//        //obtener equipos solicitados(paginados)
//        List<EquipoDAO> equiposPaginados = equipos.subList(fromIndex, toIndex);

        Stack<EquipoResponse> equiposPaginados = new Stack<>();
        for (int i = toIndex -1; i >= fromIndex; i--) {
            EquipoDAO equipoActual = equipos.get(i);

            // obtenr lista de juagdores del equipo
            List<JugadorBasico> jugadoresEquipoActual = equipoActual.getJugadores().stream()
                            .map(idJugadorActual -> jugadores.stream()
                                    .filter(j -> j.getId() == idJugadorActual)
                                    .findFirst()
                                    .orElse(null))
                            .filter(Objects::nonNull)
                            .map(JugadorBasico::new)
                            .collect(Collectors.toList());

            //EquipoResponse equipoResponse = new EquipoResponse(equipoActual, jugadoresEquipoActual);

            // respuesta con info del equipo y sus jugadores
            equiposPaginados.push(new EquipoResponse(equipoActual, jugadoresEquipoActual));
        }

        //Respuesta paginada
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_OK,
                new SuccessResponse(
                        page,
                        size,
                        equipos.size(),
                        (int) Math.ceil((double) equipos.size() / size),
                        equiposPaginados
                )
        );

//        out.println(gson.toJson(new SuccessResponse(
//                page,
//                size,
//                equipos.size(),
//                (int) Math.ceil((double) equipos.size() / size),
//                equiposPaginados
//        )));


//        if (equipos.isEmpty()) {
//            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
//            out.println(gson.toJson(new ApiResponse("No hay equipos disponibles.")));
//        } else {
//            out.println(gson.toJson(equipos));
//        }

//        out.flush();
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        JsonObject requestBody = RequestUtils.getParamsFromBody(req);

        // Validar existencia de campos en body
        if (requestBody == null ||
                !requestBody.has("nombre") || requestBody.get("nombre").getAsString().trim().isEmpty() ||
                !requestBody.has("deporte") || requestBody.get("deporte").getAsString().trim().isEmpty() ||
                !requestBody.has("fechaFundacion") || requestBody.get("fechaFundacion").getAsString().trim().isEmpty() ||
                !requestBody.has("logo") || requestBody.get("logo").getAsString().trim().isEmpty() ||
                !requestBody.has("jugadores") || requestBody.getAsJsonArray("jugadores").size() == 0
        ) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","Información para registrar un equipo incompleta.")
            );
            return;
        }


        // validar equipo reptido
        String nombre = requestBody.get("nombre").getAsString();
        System.out.println("nombre: " + nombre);
        String deporte = requestBody.get("deporte").getAsString();

        for (EquipoDAO e : equipos) {
            if (e.getNombre().equalsIgnoreCase(nombre) && e.getDeporte().equalsIgnoreCase(deporte)) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error", "Ya existe un equipo con el nombre '" + nombre + "' y deporte '" + deporte + "'.")
                );
                return;
            }
        }

        // registrar nuevo equipo
        EquipoDAO equipo = new EquipoDAO();
        equipo.setId(UniqueIDGenerator.generateEquipoID());
        equipo.setNombre(requestBody.get("nombre").getAsString());
        equipo.setDeporte(requestBody.get("deporte").getAsString());
        equipo.setFechaFundacion(requestBody.get("fechaFundacion").getAsString());
        equipo.setLogo(requestBody.get("logo").getAsString());

        //obtener lista de jugadores
        JsonArray jugadoresRequest = requestBody.getAsJsonArray("jugadores");
        Stack<Integer> jugadores = new Stack<>();
        for (JsonElement jugador : jugadoresRequest) {
            jugadores.push(jugador.getAsInt());
        }
        equipo.setJugadores(jugadores);

        //agregar equipo a la lista
        this.equipos.push(equipo);

        //respuesta
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_CREATED,
                new ApiResponse("success","Equipo creado con exito.")
        );
    }

    @Override
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        JsonObject requestBody = RequestUtils.getParamsFromBody(req);

        //obtener id a actualizar
        String id = req.getParameter("id");
        if (id == null) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","El parametro id es obligaotorio")
            );
            return;
        }

        //buscar equipo por id
        int idEquipo = Integer.parseInt(id);
        EquipoDAO findEquipo = null;
        for (EquipoDAO e : equipos) {
            if (e.getId() == idEquipo) {
                findEquipo = e;
                break;
            }
        }

        if (findEquipo == null) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_NOT_FOUND,
                    new ApiResponse("error","No se encontró el equipo con ID: " + idEquipo)
            );
            return;
        }

        //Actualizar valores que existan
        if (requestBody.has("nombre")) {
            findEquipo.setNombre(requestBody.get("nombre").getAsString());
        }
        if (requestBody.has("deporte")) {
            findEquipo.setDeporte(requestBody.get("deporte").getAsString());
        }
        if (requestBody.has("ciudad")) {
            findEquipo.setCiudad(requestBody.get("ciudad").getAsString());
        }
        if (requestBody.has("fechaFundacion")) {
            findEquipo.setFechaFundacion(requestBody.get("fechaFundacion").getAsString());
        }
        if (requestBody.has("logo")) {
            findEquipo.setLogo(requestBody.get("logo").getAsString());
        }
        if (requestBody.has("jugadores")) {
            JsonArray jugadoresRequest = requestBody.getAsJsonArray("jugadores");
            Stack<Integer> jugadores = new Stack<>();
            for (JsonElement jugador : jugadoresRequest) {
                jugadores.push(jugador.getAsInt());
            }
            findEquipo.setJugadores(jugadores);
        }

        //Respuesta con datos actualizados
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_CREATED,
                new ApiResponse("success","Equipo editado con exito.")
        );
    }
}
