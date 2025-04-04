<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="java.util.ArrayList" %>

<%--
  Created by IntelliJ IDEA.
  User: Yuri
  Date: 23/03/25
  Time: 11:59 p. m.
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    JsonArray eventos = new JsonArray();
    Set<String> deportes = new HashSet<>();
    Set<String> estados = new HashSet<>();
    URL url;

    //obtener parametros
    String deporteFiltro = request.getParameter("deporte");
    String estadoFiltro = request.getParameter("estado");
    String fechaInicioFiltro = request.getParameter("fechaInicio");
    String fechaFinFiltro = request.getParameter("fechaFin");

    // GET
    try {
        //si no hay paramtreos traer todos los eventos
        StringBuilder urlParams = new StringBuilder("http://localhost:8081/gestor-eventos-deportivos/eventos");

        boolean first = true;

        //System.out.println("---------------------");
        // Mapear parametros y si existen agregarlos a la url
        //System.out.println("deporteFiltro: " + deporteFiltro);
        if (deporteFiltro != null && !deporteFiltro.isEmpty()) {
            urlParams.append(first ? "?" : "&").append("deporte=").append(deporteFiltro);
            first = false;
        }

        //System.out.println("estadoFiltro: " + estadoFiltro);
        if (estadoFiltro != null && !estadoFiltro.isEmpty()) {
            urlParams.append(first ? "?" : "&").append("estado=").append(estadoFiltro);
            first = false;
        }

        //System.out.println("fechaInicioFiltro: " + fechaInicioFiltro);
        if (fechaInicioFiltro != null && !fechaInicioFiltro.trim().isEmpty()) {
            urlParams.append(first ? "?" : "&").append("fechaInicio=").append(fechaInicioFiltro);
            first = false;
        }

        //System.out.println("fechaFinFiltro: " + fechaFinFiltro);
        if (fechaFinFiltro != null && !fechaFinFiltro.isEmpty()) {
            urlParams.append(first ? "?" : "&").append("fechaFin=").append(fechaFinFiltro);
            first = false;
        }

        // solicitud get con url final
        url = new URL(urlParams.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        if (conn.getResponseCode() == 200) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            conn.disconnect();

            // Guardamos los eventos en la variable para reutilizarlos abajo
            eventos = JsonParser.parseString(sb.toString()).getAsJsonArray();
        }
    } catch (Exception e) {
        System.out.println("Error al conectar con el backend: " + e.getMessage());
    }

    if (eventos.size() > 0) {
        for (JsonElement registro : eventos) {
            JsonObject evento = registro.getAsJsonObject();
            deportes.add(evento.get("deporte").getAsString());
            estados.add(evento.get("estado").getAsString());
        }
    }

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

%>

<html lang="es">
<head>
    <title>GED</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="<%= request.getContextPath() %>/js/eventos.js"></script>
    <script src="<%= request.getContextPath() %>/js/webServices.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/styles/index.css">
</head>
<body class="w-full h-screen flex ">

<div class="flex w-full h-full">

    <%--    Sidebar--%>
    <div class="w-[13%] flex flex-col h-full bg-white border-r border-violet-200 px-2 py-2">
        <div class="w-full h-[20%] bg-gray-100 flex text-center border-b border-violet-200 p-1 justify-center">
            <%-- <p class="text-lg sm:text-xl md:text-2xl font-bold">Gestor de Eventos Deportivos</p> --%>
            <img class="rounded-full" src="assets/logo.png"/>
        </div>
        <div class="flex flex-col w-full h-[90%] mt-10 px-2 gap-2">
            <a href="index.jsp">
                <div class="w-full flex py-2 px-3 justify-between items-center hover:bg-violet-100 rounded-md">
                    <p class="text-gray-600 hover:text-violet-500 text-xs md:text-sm lg:text-base">
                        Estadisticas
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z"/>
                    </svg>
                </div>
            </a>
            <a href="eventos.jsp">
                <div class="w-full flex py-2 px-3 justify-between items-center bg-violet-100 rounded-md border border-violet-500">
                    <p class="text-violet-500 text-xs md:text-sm lg:text-base">
                        Eventos
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="oklch(0.446 0.03 256.802)" class="bi bi-calendar4-range" viewBox="0 0 16 16">
                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                        <path d="M9 7.5a.5.5 0 0 1 .5-.5H15v2H9.5a.5.5 0 0 1-.5-.5zm-2 3v1a.5.5 0 0 1-.5.5H1v-2h5.5a.5.5 0 0 1 .5.5"/>
                    </svg>
                </div>
            </a>
            <a href="equipos.jsp">
                <div class="w-full flex py-2 px-3 justify-between items-center hover:bg-violet-100 rounded-md">
                    <p class="text-gray-600 hover:text-violet-500 text-xs md:text-sm lg:text-base">
                        Equipos
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="oklch(0.446 0.03 256.802)" class="bi bi-flag" viewBox="0 0 16 16">
                        <path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12 12 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A20 20 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a20 20 0 0 0 1.349-.476l.019-.007.004-.002h.001M14 1.221c-.22.078-.48.167-.766.255-.81.252-1.872.523-2.734.523-.886 0-1.592-.286-2.203-.534l-.008-.003C7.662 1.21 7.139 1 6.5 1c-.669 0-1.606.229-2.415.478A21 21 0 0 0 3 1.845v6.433c.22-.078.48-.167.766-.255C4.576 7.77 5.638 7.5 6.5 7.5c.847 0 1.548.28 2.158.525l.028.01C9.32 8.29 9.86 8.5 10.5 8.5c.668 0 1.606-.229 2.415-.478A21 21 0 0 0 14 7.655V1.222z"/>
                    </svg>
                </div>
            </a>
            <a href="jugadores.jsp">
                <div class="w-full flex py-2 px-3 justify-between items-center hover:bg-violet-100 rounded-md">
                    <p class="text-gray-600 hover:text-violet-500 text-xs md:text-sm lg:text-base">
                        Jugadores
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="oklch(0.446 0.03 256.802)" class="bi bi-people" viewBox="0 0 16 16">
                        <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                    </svg>
                </div>
            </a>
        </div>
    </div>

    <%--    Content--%>
    <div class="w-[87%] h-full flex flex-col py-2">
        <div class="flex w-full h-[10%] px-2">
            <div class="w-full h-full flex flex-col py-2 px-10 items-left justify-start bg-white border-b border-violet-200">
                <p class="text-xl font-bold">Eventos</p>
                <span class="text-xs font-thin text-gray-400">Información detallada de cada evento, con sus respectivos equipos.</span>
            </div>
        </div>
        <div class="w-full h-[90%] flex flex-col px-2 py-4 bg-gray-50 gap-4">
            <div class="w-full h-[8%] flex flex-row rounded-md px-3 py-2 bg-white gap-2 border-b border-violet-200">
                <form method="get" action="eventos.jsp" class="w-[80%] flex flex-row gap-3 items-center">
                    <div class="w-[10rem] flex">
                        <select
                                class="w-full border border-gray-200 rounded-md px-2 py-1 outline-none"
                                name="deporte"
                                onchange="this.form.submit()"
                        >
                            <option selected disabled>Deporte</option>
                            <%
                                for (String deporte : deportes) {
                            %>
                            <option
                                    value="<%=deporte%>" <%= (request.getParameter("deporte") != null && request.getParameter("deporte").equals(deporte)) ? "selected" : "" %>
                            >
                                <%=deporte%>
                            </option>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="w-[10rem]">
                        <select
                                class="w-full border border-gray-200 rounded-md px-2 py-1 outline-none"
                                name="estado"
                                onchange="this.form.submit()"
                        >
                            <option selected disabled>Estado</option>
                            <%
                                for (String estado : estados) {
                            %>
                            <option
                                    value="<%=estado%>" <%= (request.getParameter("estado") != null && request.getParameter("estado").equals(estado)) ? "selected" : "" %>
                            >
                                <%= estado %>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="w-[20rem] flex flex-row gap-2">
                        <input class="w-full border border-gray-200 rounded-md px-2 py-1 outline-none" type="date"
                               name="fechaInicio"
                               onchange="this.form.submit()"
                        <%--                               value="<%= request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : null %>"--%>
                               value="<%= request.getParameter("fechaInicio") != null && !request.getParameter("fechaInicio").isEmpty() ? request.getParameter("fechaInicio") : "" %>"
                        />
                        <input class="w-full border border-gray-200 rounded-md px-2 py-1 outline-none" type="date"
                               name="fechaFin"
                               onchange="this.form.submit()"
                               value="<%= request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "" %>"
                        />
                    </div>
                    <div class="w-[20rem] flex flex-row gap-2">
                        <button type="submit"
                                class="w-auto flex flex-row bg-violet-600 text-white text-center px-2 py-1 rounded-md items-center gap-1 cursor-pointer"
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white"
                                 class="bi bi-funnel" viewBox="0 0 16 16">
                                <path d="M1.5 1.5A.5.5 0 0 1 2 1h12a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.128.334L10 8.692V13.5a.5.5 0 0 1-.342.474l-3 1A.5.5 0 0 1 6 14.5V8.692L1.628 3.834A.5.5 0 0 1 1.5 3.5zm1 .5v1.308l4.372 4.858A.5.5 0 0 1 7 8.5v5.306l2-.666V8.5a.5.5 0 0 1 .128-.334L13.5 3.308V2z"/>
                            </svg>
                            <p class="text-xs font-bold">Filtrar</p>
                        </button>

                        <button type="reset"
                                class="w-auto flex flex-row bg-violet-600 text-white text-center px-2 py-1 rounded-md items-center gap-1 cursor-pointer"
                                onclick="limpiarFiltros(event)"
                        >
                            <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                 viewBox="0 0 24 24">
                                <path stroke="currentColor" stroke-linecap="round" stroke-width="2"
                                      d="m21 21-3.5-3.5M17 10a7 7 0 1 1-14 0 7 7 0 0 1 14 0Z"/>
                            </svg>
                            <p class="text-xs font-bold">Limpiar</p>
                        </button>
                    </div>
                </form>
                <div class="w-[20%] flex justify-end">
                    <div class="w-[20rem] flex justify-end">
                        <button type="button"
                                class="w-auto flex flex-row bg-violet-600 text-white text-center px-2 py-1 rounded-md items-center gap-1 cursor-pointer"
                                onclick="abrirModal('postEvento')"

                        >
                            <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                 viewBox="0 0 24 24">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="2" d="M5 12h14m-7 7V5"/>
                            </svg>
                            <p class="text-xs font-bold">Agregar Evento</p>
                        </button>
                    </div>
                </div>
            </div>


            <div class="w-full h-[92%] flex flex-col bg-white rounded-md px-2 py-2 gap-1 border-b border-violet-200">
                <%-- Encabezado  --%>
                <div class="w-full h-[7.5vh] grid grid-cols-8 bg-violet-100 rounded-md px-1 gap-2 items-center border border-violet-200 sticky top-0 z-10">
                    <div class="border-r border-violet-300">Nombre del Evento</div>
                    <div class="border-r border-violet-300">Fecha</div>
                    <div class="border-r border-violet-300">Lugar</div>
                    <div class="border-r border-violet-300">Deporte</div>
                    <div class="border-r border-violet-300">Capacidad</div>
                    <div class="border-r border-violet-300">Entradas Vendidas</div>
                    <div class="border-r border-violet-300">Estado</div>
                    <div>Participantes</div>
                </div>

                <%-- Cuerpo de la tabla --%>
                <div class="w-full max-h-[65vh] overflow-y-auto">
                    <%
                        if (eventos.size() > 0) {
                            for (JsonElement registro : eventos) {
                                JsonObject evento = registro.getAsJsonObject();
                                deportes.add(evento.get("deporte").getAsString());
                    %>
                    <div class="w-full h-[5vh] grid grid-cols-8 bg-gray-50 rounded-md px-1 gap-2 items-center text-xs border border-violet-200 mb-1"
                         onclick="abrirModal('putEvento', <%= evento.get("id").getAsInt() %> )">


                        <div class="text-gray-700"><%= evento.get("nombre").getAsString() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("fecha").getAsString() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("lugar").getAsString() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("deporte").getAsString() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("capacidad").getAsInt() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("entradasVendidas").getAsInt() %>
                        </div>
                        <div class="text-gray-700"><%= evento.get("estado").getAsString() %>
                        </div>
                        <div class="flex gap-1">
                            <%
                                JsonArray jsonEquipos = evento.get("equiposParticipantes").getAsJsonArray();
                                for (int i = 0; i < jsonEquipos.size(); i++) {
                            %>
                            <div class="bg-violet-200 px-1 rounded-md text-gray-700"><%= jsonEquipos.get(i).getAsString() %>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>


                    <% }
                    } else {
                    %>
                    <div class="w-full h-[5vh] flex justify-center bg-gray-50 rounded-md px-1 gap-2 items-center text-xs">
                        <div class="flex text-gray-700 items-center text-center">No hay eventos.</div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modales -->
<div id="postEvento"
     class="fixed inset-0 bg-gradient-to-b from-gray-900/50 to-gray-900/20 flex items-center justify-center hidden z-50">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/3 gap-1">
        <div class="w-full flex flex-col px-2 gap-1 cursor-pointer justify-center px-5">
            <h2 class="px-2 text-xl font-bold rounded-md bg-violet-400 text-white">
                Crear Evento
            </h2>
            <div class="w-full h-0.5 bg-violet-600 flex justify-center center"></div>
        </div>
        <form class="flex flex-col gap-1 mt-2" onsubmit="crearEvento(event)">
            <div class="w-full flex flex-col">
                <label class="text-xs">Nombre del Evento:</label>
                <input type="text" id="nombre" name="nombre"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col">
                <label class="text-xs">Fecha:</label>
                <input type="date" name="fecha" id="fecha"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col">
                <label class="text-xs">Lugar:</label>
                <input type="text" id="lugar" name="lugar"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col">
                <label class="text-xs">Deporte:</label>
                <input type="text" id="deporte" name="deporte"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col mb-2">
                <label class="text-xs">Selecciona los equipos:</label>
                <div class="grid grid-cols-3 lg:grid-cols-6 items-center text-xs gap-2" id="equipos-container">
                    <% for (JsonElement registroEquipo : equipos) {
                        JsonObject equipo = registroEquipo.getAsJsonObject();
                    %>
                    <div class="flex flex-row gap-1 items-center">
                        <label class="px-2">
                            <input type="checkbox" name="equiposParticipantes" id="equiposParticipantes"
                                   value="<%= equipo.get("id").getAsInt() %>"/><%= equipo.get("nombre").getAsString() %>
                        </label>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <div class="w-full flex flex-col">
                <label class="text-xs">Capacidad:</label>
                <input type="number" id="capacidad" name="capacidad"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col">
                <label class="text-xs">Entradas vendidas:</label>
                <input type="number" id="entradasVendidas" name="entradasVendidas"
                       class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
            </div>
            <div class="w-full flex flex-col">
                <label class="text-xs">Estado:</label>
                <select id="estado" name="estado"
                        class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                    <option value="" selected disabled>Selecciona un estado</option>
                    <option value="Programado">Programado</option>
                    <option value="En curso">En curso</option>
                    <option value="Finalizado">Finalizado</option>
                    <option value="Cancelado">Cancelado</option>
                </select>
            </div>
            <div class="flex justify-end gap-2 mt-4">
                <button type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                        onclick="cerrarModal('postEvento')">
                    Cancelar
                </button>
                <button type="submit" class="px-4 py-2 bg-violet-600 text-white rounded-md">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="putEvento"
     class="fixed inset-0 bg-gradient-to-b from-gray-900/50 to-gray-900/20 flex items-center justify-center hidden z-50">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/3 flex flex-col gap-10">
        <div class="w-full flex flex-col justify-between items-center gap-5">
            <div class="w-full flex flex-row justify-between">
                <div class="w-[50%] flex flex-col px-2 gap-1 cursor-pointer justify-center"
                     onclick="mostrarContainer('venderEntradas')">
                    <h2 class="px-2 text-xl font-bold rounded-md bg-violet-400 text-white">
                        Comprar Entradas
                    </h2>
                    <div id="divVenderEntradas" class="w-full h-0.5 bg-violet-600 flex justify-center center"></div>
                </div>
                <div class="w-[50%] flex flex-col px-2 gap-1 cursor-pointer justify-center"
                     onclick="mostrarContainer('actualizarEstado')">
                    <h2 class="px-2 text-xl font-bold rounded-md bg-violet-400 text-white">
                        Actualizar Estado
                    </h2>
                    <div id="divActualizarEstado"
                         class="w-full h-0.5 bg-white-600 flex justify-center items-center"></div>
                </div>

                <div class="w-[50%] flex flex-col px-2 gap-1 cursor-pointer justify-center"
                     onclick="mostrarContainer('actualizarEvento')">
                    <h2 class="px-2 text-xl font-bold rounded-md bg-violet-400 text-white">
                        Editar Evento
                    </h2>
                    <div id="divEditarEvento" class="w-full h-0.5 bg-white-600 flex justify-center items-center"></div>
                </div>
            </div>

            <div class="px-2 w-full flex flex-row gap-1 items-center">
                <p class="block text-base font-bold">ID Evento: </p>
                <input class="text-lg" id="entradasComprarId" type="number" readonly>
            </div>

            <form id="venderEntradas" class="w-full flex flex-col" onsubmit="PUTData(event, 'venderEntradas')">
                <div class="w-full px-2 mb-4 gap-2">
                    <label class="w-full text-sm font-medium">Numero de entradas a comprar:</label>
                    <input type="number" id="entradasComprar" name="entradasComprar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none" required>
                </div>
                <div class="flex justify-end gap-2 mt-4">
                    <button
                            type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                            onclick="cerrarModal('putEvento')"
                    >
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 bg-violet-600 text-white rounded-md">Guardar</button>
                </div>
            </form>

            <form id="actualizarEstado" class="w-full flex flex-col hidden"
                  onsubmit="PUTData(event, 'actualizarEstado')">
                <div class="w-full px-2 mb-4 gap-2">
                    <label class="w-full text-sm font-medium">Nuevo estado del evento:</label>
                    <select id="estadoActualizar" name="estadoActualizar"
                            class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none" required>
                        <option value="" selected disabled>Selecciona un estado</option>
                        <option value="Programado">Programado</option>
                        <option value="En curso">En curso</option>
                        <option value="Finalizado">Finalizado</option>
                        <option value="Cancelado">Cancelado</option>
                    </select>
                </div>

                <div class="flex justify-end gap-2 mt-4">
                    <button
                            type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                            onclick="cerrarModal('putEvento')"
                    >
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 bg-violet-600 text-white rounded-md">Guardar</button>
                </div>
            </form>

            <form id="actualizarEvento" class="flex flex-col gap-1 mt-2 hidden"
                  onsubmit="PUTData(event, 'actualizarEvento')">
                <div class="w-full flex flex-col">
                    <label class="text-xs">Nombre del Evento:</label>
                    <input type="text" id="nombreActualizar" name="nombreActualizar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                </div>
                <div class="w-full flex flex-col">
                    <label class="text-xs">Fecha:</label>
                    <input type="date" name="fechaActualizar" id="fechaActualizar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                </div>
                <div class="w-full flex flex-col">
                    <label class="text-xs">Lugar:</label>
                    <input type="text" id="lugarActualizar" name="lugarActualizar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                </div>
                <div class="w-full flex flex-col">
                    <label class="text-xs">Deporte:</label>
                    <input type="text" id="deporteActualizar" name="deporteActualizar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                </div>
                <div class="w-full flex flex-col mb-2 mt-2">
                    <label class="text-xs">Selecciona los equipos:</label>
                    <div class="grid grid-cols-3 lg:grid-cols-6 items-center text-xs gap-2"
                         id="equipos-container-actualizar">
                        <% for (JsonElement registroEquipo : equipos) {
                            JsonObject equipo = registroEquipo.getAsJsonObject();
                        %>
                        <div class="flex flex-row gap-1 items-center">
                            <label>
                                <input type="checkbox" name="equiposParticipantesActualizar"
                                       id="equiposParticipantesActualizar"
                                       value="<%= equipo.get("id").getAsInt() %>"/><%= equipo.get("nombre").getAsString() %>
                            </label>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>

                <div class="w-full flex flex-col">
                    <label class="text-xs">Capacidad:</label>
                    <input type="number" id="capacidadActualizar" name="capacidadActualizar"
                           class="w-full border border-gray-300 rounded-md px-2 py-1 outline-none text-xs" required>
                </div>
                <div class="flex justify-end gap-2 mt-4">
                    <button type="button" class="px-4 py-2 bg-gray-500 text-white rounded-md"
                            onclick="cerrarModal('putEvento')">
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
