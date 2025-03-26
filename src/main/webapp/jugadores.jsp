<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils" %>
<%@ page import="java.util.Stack" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: Yuri
  Date: 24/03/25
  Time: 10:27 p. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%


    // GET Jugadores
    JsonArray jugadores = RequestUtils.getJsonArrayFromUrl("http://localhost:8081/gestor-eventos-deportivos/jugadores");

    // GET equipos
    String baseUrlEquuipos = "http://localhost:8081/gestor-eventos-deportivos/equipos";
    int pageEquipos = 1;
    int sizeEquipos = 1;
    int totalPagesEquipos = 1;
    JsonArray equipos = new JsonArray();

    do {
        JsonObject jsonResponseEquipos = RequestUtils.getJsonObjectFromUrl(baseUrlEquuipos + "?page=" + pageEquipos + "&size=" + sizeEquipos);
        totalPagesEquipos = jsonResponseEquipos.get("totalPages").getAsInt();
        JsonArray dataEquipos = jsonResponseEquipos.get("data").getAsJsonArray();

        for (int i = 0; i < dataEquipos.size(); i++) {
            equipos.add(dataEquipos.get(i));
        }

        pageEquipos++;
    } while (pageEquipos <= totalPagesEquipos);

//    URL url;
//    try {
//
//        System.out.println("---------------------");
//
//        StringBuilder urlParams = new StringBuilder("http://localhost:8081/gestor-eventos-deportivos/jugadores");
//
////        String trasferirJugador = request.getParameter("trasferirJugador");
////        String jugadoresTransferirId = request.getParameter("jugadoresTransferirId");
////
////        if (trasferirJugador != null && !trasferirJugador.isEmpty() && jugadoresTransferirId != null && !jugadoresTransferirId.isEmpty()) {
////            int idJugador = Integer.parseInt(jugadoresTransferirId);
////            urlParams.append("transferir?jugadorId="+idJugador+"&equipoDestino="+trasferirJugador);
////        }
//
//        // solicitud get
//        url = new URL(urlParams.toString());
//        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//        conn.setRequestMethod("GET");
//        conn.setRequestProperty("Accept", "application/json");
//
//        if (conn.getResponseCode() == 200) {
//            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//            StringBuilder sb = new StringBuilder();
//            String line;
//            while ((line = br.readLine()) != null) {
//                sb.append(line);
//            }
//            conn.disconnect();
//
//            // Guardamos los equipos en la variable para reutilizarlos abajo
//            jugadores = JsonParser.parseString(sb.toString()).getAsJsonArray();
////            System.out.println(jugadores);
//        }
//    } catch (Exception e) {
//        System.out.println("Error al conectar con el backend: " + e.getMessage());
//    }

    // GET equipos


//    do {
//        try {
//            URL urlEquipos = new URL(baseUrlEquuipos + "?page=" + pageEquipos + "&size=" + sizeEquipos);
//            HttpURLConnection conn = (HttpURLConnection) urlEquipos.openConnection();
//            conn.setRequestMethod("GET");
//            conn.setRequestProperty("Accept", "application/json");
//
//            if (conn.getResponseCode() == 200) {
//                BufferedReader brEquipos = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//                StringBuilder responseEquipos = new StringBuilder();
//                String line;
//                while ((line = brEquipos.readLine()) != null) {
//                    responseEquipos.append(line);
//                }
//                brEquipos.close();
//
//                //convertir respuesta
//                JsonObject jsonResponseEquipos = new JsonObject(responseEquipos.toString());
//                totalPagesEquipos = jsonResponseEquipos.get("totalPages").getAsInt();
//                JsonArray dataEquipos = jsonResponseEquipos.get("data").getAsJsonArray();
//
//                // Guardamos todos los equipos
//                for (int i = 0; i < dataEquipos.size(); i++) {
//                    equipos.put(dataEquipos.get(i).getAsJsonArray());
//                }
//
//                System.out.println(jugadores);
//            }
//
//            conn.disconnect();
//            pageEquipos++;
//        } catch (Exception e) {
//            System.out.println("Error al conectar con el backend: " + e.getMessage());
//        }
//    } while (page <= totalPagesEquipos);

%>

<html>
<head>
    <title>GED</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/styles/index.css">
    <script src="<%= request.getContextPath() %>/js/eventos.js"></script>
    <script src="<%= request.getContextPath() %>/js/jugadores.js"></script>
    <script src="<%= request.getContextPath() %>/js/webServices.js"></script>
</head>
<body class="w-full h-screen flex">
<div class="flex w-full h-full">

    <%--    Sidebar--%>
    <div class="w-[13%] flex flex-col h-full bg-white border-r border-violet-200 px-2 py-2">
        <div class="w-full h-[10%] flex text-center border-b border-violet-200">
            <p class="text-lg font-bold">Gestor de Eventos Deportivos</p>
        </div>
        <div class="flex flex-col w-full h-[90%] mt-10 px-2 gap-2">
            <a href="index.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md">
                    <p class="px-8 py-2 text-gray-600 hover:text-violet-500">
                        Estadisticas
                    </p>
                </div>
            </a>
            <a href="eventos.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md">
                    <p class="px-8 py-2 text-gray-600 hover:text-violet-500">
                        Eventos
                    </p>
                </div>
            </a>
            <a href="equipos.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md">
                    <p class="px-8 py-2 text-gray-600 hover:text-violet-500">
                        Equipos
                    </p>
                </div>
            </a>
            <a href="jugadores.jsp">
                <div class="w-full flex items-center bg-violet-100 rounded-md border border-violet-500">
                    <p class="px-8 py-2 text-violet-500">
                        Jugadores
                    </p>
                </div>
            </a>
        </div>
    </div>

    <%--    Content--%>
    <div class="w-[87%] h-full flex flex-col py-2">

        <div class="flex w-full h-[10%] px-2">
            <div class="w-full h-full flex flex-row py-2 px-10 justify-between bg-white border-b border-violet-200">
                <div class="w-[80%] flex flex-col">
                    <p class="text-xl font-bold">Jugadores</p>
                    <span class="text-xs font-thin text-gray-400">Información detallada de cada jugador.</span>
                </div>
                <div class="w-[20%] flex">
                    <div class="w-[20rem] flex justify-end">
                        <button type="button"
                                class="w-[10rem] h-[3rem] flex flex-row bg-violet-600 text-white text-center px-2 py-1 rounded-md items-center gap-1 cursor-pointer"
                                onclick="abrirModal('postJugador')"
                        >
                            <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                 viewBox="0 0 24 24">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="2" d="M5 12h14m-7 7V5"/>
                            </svg>
                            <p class="text-xs font-bold">Agregar Jugador</p>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="w-full h-[90%] flex flex-col overflow-auto bg-gray-50">
            <div class="w-full grid grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4 p-2">

                <%
                    if (jugadores.size() > 0) {
                        for (JsonElement registro : jugadores) {
                            JsonObject jugador = registro.getAsJsonObject();
                            boolean estado = jugador.get("estadoActivo").getAsBoolean();

                %>
                <div class="flex flex-col justify-between bg-white rounded-lg shadow-lg overflow-hidden border border-violet-200 hover:shadow-xl transition-shadow duration-300">
                    <!-- Card Header -->
                    <div class="flex justify-between items-center bg-violet-50 px-2 py-1 border-b border-violet-100">
                        <div class="flex items-center gap-1">
                            <div class="w-[2rem] h-[2rem] flex items-center justify-center bg-violet-600 text-white rounded-full font-bold text-xs">
                                #<%= jugador.get("numero").getAsInt() %>
                            </div>
                            <p class="text-xs font-bold text-gray-800"><%= jugador.get("nombre").getAsString() %> <%= jugador.get("apellido").getAsString() %>
                            </p>
                        </div>
                        <span class="px-2 py-1 rounded-full text-xs font-semibold <%= (estado) ? "bg-green-200 text-green-800" : "bg-red-200 text-red-800" %>"><%= (estado) ? "Activo" : "Inactivo" %></span>
                    </div>

                    <!-- Card Body -->
                    <div class="flex px-1 py-2">
                        <%--                        <div class="grid grid-cols-2 gap-3 text-xs">--%>
                        <div class="flex flex-col text-xs gap-3 px-2">
                            <div class="flex flex-col">
                                <p class="text-gray-600">Fecha de Nacimiento</p>
                                <p class="font-medium text-gray-900"><%= jugador.get("fechaNacimiento").getAsString() %>
                                </p>
                            </div>
                            <div class="flex flex-col">
                                <p class="text-gray-600">Nacionalidad</p>
                                <p class="font-medium text-gray-900"><%= jugador.get("nacionalidad").getAsString() %>
                                </p>
                            </div>
                            <div class="flex flex-col">
                                <p class="text-gray-600">Posición</p>
                                <p class="font-medium text-gray-900"><%= jugador.get("posicion").getAsString() %>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Card Footer -->
                    <div class="w-full flex row bg-gray-50 px-2 py-1 border-t border-violet-200 gap-1 justify-center items-center">
                        <div class="w-[40%] flex flex-col border-r border-violet-200 justify-center items-center">
                            <%--                            <span class="text-sm text-gray-700"># Equipo</span>--%>
                            <div class="bg-indigo-300 rounded-md flex items-center justify-center px-2 py-1">
                                <span class="text-xs text-gray-600"
                                      title="Número equipo"><%= jugador.get("equipoId").getAsInt() %></span>
                            </div>
                        </div>
                        <div class="w-[40%] flex flex-col justify-center items-center border-r border-violet-200">
                            <%--                            <span class="text-sm text-gray-700">Nombre Equipo</span>--%>
                            <div class="bg-fuchsia-300 rounded-md flex items-center justify-center px-2 py-1">
                                <span class="text-xs text-gray-600"
                                      title="Nombre equipo"><%= jugador.get("equipoNombre").getAsString() %></span>
                            </div>
                        </div>
                        <div class="w-[20%] flex flex-col justify-center items-center cursor-pointer"
                             onclick="abrirModal('getTransferir', <%= jugador.get("id").getAsInt() %>)">
                            <span title="Trasferir jugador">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                     fill="oklch(0.446 0.03 256.802)" class="bi bi-arrow-left-right"
                                     viewBox="0 0 16 16">
                                    <path fill-rule="evenodd"
                                          d="M1 11.5a.5.5 0 0 0 .5.5h11.793l-3.147 3.146a.5.5 0 0 0 .708.708l4-4a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 11H1.5a.5.5 0 0 0-.5.5m14-7a.5.5 0 0 1-.5.5H2.707l3.147 3.146a.5.5 0 1 1-.708.708l-4-4a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 4H14.5a.5.5 0 0 1 .5.5"/>
                                </svg>
                            </span>
                        </div>

                        <%--                        <div class="flex items-center px-2 py-1 gap-2 justify-between">--%>
                        <%--                            <div>--%>
                        <%--                                <span>#</span>--%>
                        <%--                                <div class="bg-indigo-300 rounded-md flex items-center justify-center px-2 py-1">--%>
                        <%--                                    <span class="text-xs"><%= jugador.get("equipoId").getAsInt() %></span>--%>
                        <%--                                </div>--%>
                        <%--                            </div>--%>
                        <%--                            <div>--%>
                        <%--                                <span>Nombre</span>--%>
                        <%--                                <div class="bg-fuchsia-300 rounded-md flex items-center justify-center px-2 py-1">--%>
                        <%--                                    <span class="text-xs"><%= jugador.get("equipoNombre").getAsString() %></span>--%>
                        <%--                                </div>--%>
                        <%--                            </div>--%>
                        <%--                        </div>--%>


                    </div>
                </div>

                <%
                        }
                    }

                %>
            </div>
        </div>
    </div>
</div>

<!-- Modales -->
<div id="postJugador"
     class="fixed inset-0 bg-gradient-to-b from-gray-900/50 to-gray-900/20 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/3">
        <h2 class="text-xl font-bold mb-4">Agregar Evento</h2>
        <form action="eventos.jsp" method="post">
            <div class="mb-2">
                <label class="block text-sm font-medium">Nombre del Evento:</label>
                <input type="text" id="nombre" name="nombre"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Fecha:</label>
                <input type="date" name="fecha"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Lugar:</label>
                <input type="text" id="lugar" name="lugar"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Deporte:</label>
                <input type="text" id="deporte" name="deporte"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-3">
                <%--                <label class="block text-sm font-medium">Equipos participantes:</label>--%>
                <%--                <select type="text" id="equiposParticipantes" name="equiposParticipantes"--%>
                <%--                        class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none"--%>
                <%--                        multiple--%>
                <%--                >--%>
                <%--                    <option value="1">1</option>--%>
                <%--                    <option value="2">2</option>--%>
                <%--                    <option value="3">3</option>--%>

                <%--                </select>--%>
                <label>Selecciona equipos:</label>
                <div class="grid grid-cols-3 lg:grid-cols-6 items-center" id="equipos-container">
                    <label><input type="checkbox" name="equipos" value="1"> Equipo 1</label><br>
                    <label><input type="checkbox" name="equipos" value="2"> Equipo 2</label><br>
                    <label><input type="checkbox" name="equipos" value="3"> Equipo 3</label><br>
                    <label><input type="checkbox" name="equipos" value="4"> Equipo 4</label><br>
                    <label><input type="checkbox" name="equipos" value="5"> Equipo 5</label><br>
                </div>

            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Capacidad:</label>
                <input type="text" id="capacidad" name="capacidad"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Entradas:</label>
                <input type="text" id="entradasVendidas" name="entradasVendidas"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="mb-2">
                <label class="block text-sm font-medium">Estado:</label>
                <input type="text" id="estado" name="estado"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none">
            </div>
            <div class="flex justify-end gap-2 mt-4">
                <button type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                        onclick="cerrarModal('postJugador')">
                    Cancelar
                </button>
                <button type="submit" class="px-4 py-2 bg-violet-600 text-white rounded-md">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="getTransferir" class="fixed inset-0 bg-gradient-to-b from-gray-900/50 to-gray-900/20 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/3 flex flex-col gap-10">
        <div class="w-full flex flex-col justify-between items-center gap-5">
            <div class="w-full flex flex-col px-2 gap-1 cursor-pointer justify-center px-5">
                <h2 class="px-2 text-xl font-bold rounded-md bg-violet-400 text-white">
                    Trasferir Jugadores
                </h2>
                <div class="w-full h-0.5 bg-violet-600 flex justify-center center"></div>
            </div>

            <div class="px-2 w-full flex flex-row gap-1 items-center">
                <p class="block text-base font-bold">ID Jugador: </p>
                <input class="text-lg" id="jugadoresTransferirId" name="jugadoresTransferirId" type="number" readonly>
            </div>

            <form class="w-full flex flex-col" onsubmit="transferirJugador(event)">
                <div class="w-full px-2 mb-4 gap-2">
                    <label class="w-full text-sm font-medium">Nuevo equipo a transferir:</label>
                    <select id="trasferirJugador" name="trasferirJugador" class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none" required>
                        <option value="" selected disabled>Selecciona un equipo</option>
                        <% for (JsonElement equipoActualizar : equipos) {
                            JsonObject equipo = equipoActualizar.getAsJsonObject();
                        %>
                            <option value="<%= equipo.get("id").getAsInt() %>"><%= equipo.get("nombre").getAsString()%></option>
                        <% } %>

                    </select>
                </div>

                <div class="flex justify-end gap-2 mt-4">
                    <button
                            type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                            onclick="cerrarModal('getTransferir')"
                    >
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 bg-violet-600 text-white rounded-md">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
