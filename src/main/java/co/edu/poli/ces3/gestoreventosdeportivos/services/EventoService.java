package co.edu.poli.ces3.gestoreventosdeportivos.services;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EventoResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.ApiResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class EventoService {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static void actualizarEvento(EventoDAO evento, JsonObject requestBody, HttpServletResponse response, Stack<EquipoDAO> equiposSelectACtualizar) throws ServletException, IOException {

        if (requestBody.has("nombre")) evento.setNombre(requestBody.get("nombre").getAsString());
        if (requestBody.has("fecha")) evento.setFecha(requestBody.get("fecha").getAsString());
        if (requestBody.has("lugar")) evento.setLugar(requestBody.get("lugar").getAsString());
        if (requestBody.has("deporte")) evento.setDeporte(requestBody.get("deporte").getAsString());

        if (requestBody.has("equiposParticipantes")) {
            JsonArray equiposParticipantesActual = requestBody.get("equiposParticipantes").getAsJsonArray();
            if (equiposParticipantesActual.size() < 2){
                RequestUtils.sendJsonResponse(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","El evento debe tener como minimo 2 equipos participantes.")
                );
                return;
            }

            //validar que los equipos del evento sean del mismo deporte
            Set<String> deportesEvento = new HashSet<>();
            List<EquipoDAO> equiposSeleccionados = new ArrayList<>();

            for (JsonElement idEquipoEvento: equiposParticipantesActual) {
                int idEquipo = idEquipoEvento.getAsInt();
                boolean equipoEncontrado = false;

                for (EquipoDAO equipo : equiposSelectACtualizar) {
                    if (equipo.getId() == idEquipo) {
                        deportesEvento.add(equipo.getDeporte());
                        equiposSeleccionados.add(equipo);
                        equipoEncontrado = true;
                        break;
                    }
                }

                if (!equipoEncontrado) {
                    RequestUtils.sendJsonResponse(
                            response,
                            HttpServletResponse.SC_BAD_REQUEST,
                            new ApiResponse("error", "El equipo con ID " + idEquipo + " no existe.")
                    );
                    return;
                }
            }

            // si hay más de un deporte en la lista, los equipos no son del mismo deporte
            if (deportesEvento.size() > 1) {
                RequestUtils.sendJsonResponse(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","Los equipos deben tener el mismo deporte.")
                );
                return;
            }

            Stack equiposActualizar = new Stack<>();
            for (JsonElement elemt : equiposParticipantesActual) {
                equiposActualizar.push(elemt.getAsInt());
            }
            evento.setEquiposParticipantes(equiposActualizar);
        }

        if (requestBody.has("capacidad")) evento.setCapacidad(requestBody.get("capacidad").getAsInt());

         RequestUtils.sendJsonResponse(
                response,
                HttpServletResponse.SC_OK,
                new ApiResponse("success","Evento actualizado..")
        );
    }

    public static void venderEntradas(EventoDAO evento, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (!RequestUtils.validateParams(response, request.getParameter("cantidad"), "La nueva cantidad del evento es obligatoria.")) return;

        //validar parametro cantidad
        int cantidad;
        try {
            cantidad = Integer.parseInt(request.getParameter("cantidad"));
        } catch (NumberFormatException ex) {
            RequestUtils.sendJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error", "La cantidad del evento debe ser un número válido.")
            );
            return;
        }

        int totalEntradasDisponibles = evento.getCapacidad() - evento.getEntradasVendidas();
        if (cantidad > totalEntradasDisponibles) {
            RequestUtils.sendJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","El evento no tiene suficiente entradas disponibles.")
            );
            return;
        }

        evento.setEntradasVendidas(evento.getEntradasVendidas() + cantidad);

        RequestUtils.sendJsonResponse(
                response,
                HttpServletResponse.SC_OK,
                new ApiResponse("success","Las " + cantidad + " entradas para el evento " + evento.getNombre() + " se vendieron con exito.")
        );
    }

    public static void actualizarEstado(EventoDAO evento, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        if (!RequestUtils.validateParams(response, request.getParameter("estado"), "El estado del evento es obligatorio.")) {
            return;
        }

        String estado = request.getParameter("estado");
        ArrayList<String> estadosValidos = new ArrayList<>(Arrays.asList("Programado", "En curso", "Finalizado", "Cancelado"));
        if (!estadosValidos.contains(estado)) {
            RequestUtils.sendJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","El estado proporcionado no es válido.")
            );
            return;
        }

        evento.setEstado(estado);

        RequestUtils.sendJsonResponse(
                response,
                HttpServletResponse.SC_OK,
                new ApiResponse("success","Se ha actualiza a estado '" + estado + "' el evento " + evento.getNombre() + " con exito.")
        );

    }

    public static Stack<EventoResponse> filtrarEventos(Stack<EventoResponse> eventos, String deporte, String estado, String fechaInicioStr, String fechaFinStr) {

        return eventos.stream()
                .filter(e -> deporte == null || e.getDeporte().equalsIgnoreCase(deporte))
                .filter(e -> estado == null || e.getEstado().equalsIgnoreCase(estado))
                .filter(e -> {
                    if (fechaInicioStr != null || fechaFinStr != null) {
                        LocalDate fechaEvento = LocalDate.parse(e.getFecha(), formatter);
                        LocalDate fechaInicio = fechaInicioStr != null ? LocalDate.parse(fechaInicioStr) : null;
                        LocalDate fechaFin = fechaFinStr != null ? LocalDate.parse(fechaFinStr) : null;
                        return (fechaInicio == null || !fechaEvento.isBefore(fechaInicio)) && (fechaFin == null || !fechaEvento.isAfter(fechaFin));

//                        LocalDate fechaInicio = LocalDate.parse(fechaInicioStr, formatter);
//                        LocalDate fechaFin = LocalDate.parse(fechaFinStr, formatter);
//                        return !fechaEvento.isBefore(fechaInicio) && !fechaEvento.isAfter(fechaFin);
                    }
                    return true;
                })
                .collect(Collectors.toCollection(Stack::new));
    }
}
