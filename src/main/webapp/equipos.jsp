<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonObject" %><%--
  Created by IntelliJ IDEA.
  User: Yuri
  Date: 24/03/25
  Time: 4:09 p. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JsonObject dataEquipos = new JsonObject();
    JsonArray equipos = new JsonArray();

    URL url;

    //obtener parametros
    Integer pageData = 1;
    Integer sizeData = 1;

    try {

//        System.out.println("---------------------");
        //mapear parametros y agregarlos a la url
        try {
//            System.out.println("pageData: " + pageData);
            if (request.getParameter("page") != null) {
                pageData = Integer.parseInt(request.getParameter("page"));
            }

//            System.out.println("sizeData: " + sizeData);
            if (request.getParameter("size") != null) {
                sizeData = Integer.parseInt(request.getParameter("size"));
            }
        } catch (NumberFormatException e) {
            System.out.println("Error en los parámetros de paginación: " + e.getMessage());
        }

        StringBuilder urlParams = new StringBuilder("http://localhost:8081/gestor-eventos-deportivos/equipos?page=" + pageData + "&size=" + sizeData);

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

            // Guardamos los equipos en la variable para reutilizarlos abajo
            dataEquipos = JsonParser.parseString(sb.toString()).getAsJsonObject();
            equipos = dataEquipos.get("data").getAsJsonArray();
//            System.out.println(dataEquipos);
        }
    } catch (Exception e) {
        System.out.println("Error al conectar con el backend: " + e.getMessage());
    }
%>


<html>
<head>
    <title>GED</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="<%= request.getContextPath() %>/js/eventos.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/styles/index.css">
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
                <div class="w-full flex items-center bg-violet-100 rounded-md border border-violet-500">
                    <p class="px-8 py-2 text-violet-500">
                        Equipos
                    </p>
                </div>
            </a>
            <a href="jugadores.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md">
                    <p class="px-8 py-2 text-gray-600 hover:text-violet-500">
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
                    <p class="text-xl font-bold">Equipos</p>
                    <span class="text-xs font-thin text-gray-400">Información detallada de cada equipop, con sus respectivos equipos.</span>
                </div>
                <div class="w-[20%] flex">
                    <div class="w-[20rem] flex justify-end">
                        <button type="submit"
                                class="w-[10rem] h-[3rem] flex flex-row bg-violet-600 text-white text-center px-2 py-1 rounded-md items-center gap-1 cursor-pointer">
                            <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                 viewBox="0 0 24 24">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="2" d="M5 12h14m-7 7V5"/>
                            </svg>
                            <p class="text-xs font-bold">Agregar Equipo</p>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <%--        <div class="w-full h-[90%] flex flex-col px-2 py-4 bg-gray-50 gap-4">--%>
        <div class="w-full h-[80%]">
            <div class="w-full h-full grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 bg-gray-50 gap-4 p-2">
                <%--            <div class="w-[15rem] h-[20rem] flex flex-col rounded-md px-3 py-2 gap-2 border border-violet-200">--%>

                <%
                    if (equipos.size() > 0) {
                        for (JsonElement registro : equipos) {
                            JsonObject equipo = registro.getAsJsonObject();
                            JsonArray jugadores = equipo.get("jugadores").getAsJsonArray();
                %>

                <div class="bg-white h-full rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow border border-violet-200">
                    <%--                    h-full md:h-screen lg:h-[50%]--%>

                    <div class="w-full flex py-2 mb-5">
                        <div class="w-full h-full flex flex-col justify-center items-center">
                            <img src="<%= equipo.get("logo").getAsString() %>"
                                 alt="logo"
                                 class="w-[3rem] h-[3rem] rounded-full"
                            />
                            <div class="w-full flex flex-col text-center justify-center items-center">
                                <p class="text-lg font-bold"><%= equipo.get("nombre").getAsString() %>
                                </p>
                                <p class="w-[5rem] bg-violet-600 text-white text-xs font-bold rounded-md"><%= equipo.get("deporte").getAsString() %>
                                </p>
                            </div>
                        </div>
                    </div>


                    <div class="w-full flex flex-col items-center text-xs px-2 gap-2">
                        <div class="w-full flex flex-row items-center gap-1 px-2">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="gray"
                                 class="bi bi-geo-alt"
                                 viewBox="0 0 16 16">
                                <path d="M12.166 8.94c-.524 1.062-1.234 2.12-1.96 3.07A32 32 0 0 1 8 14.58a32 32 0 0 1-2.206-2.57c-.726-.95-1.436-2.008-1.96-3.07C3.304 7.867 3 6.862 3 6a5 5 0 0 1 10 0c0 .862-.305 1.867-.834 2.94M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10"/>
                                <path d="M8 8a2 2 0 1 1 0-4 2 2 0 0 1 0 4m0 1a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
                            </svg>
                            <p class="text-xs text-gray-600"><%= equipo.get("ciudad").getAsString() %>
                            </p>
                        </div>

                        <div class="w-full flex flex-row items-center gap-1 px-2 py-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="gray"
                                 class="bi bi-calendar-event" viewBox="0 0 16 16">
                                <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"/>
                            </svg>
                            <p class="text-xs text-gray-600">Fecha
                                fundación: <%= equipo.get("fechaFundacion").getAsString() %>
                            </p>
                        </div>

                        <%--                    JUgadores--%>
                        <div
                                class="w-full flex flex-col gap-1"
                        >
                            <div class="flex flex-row gap-1 bg-violet-50 rounded-lg px-2 py-1 justify-between">
                                <div class="flex flex-row gap-1 items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="black"
                                         class="bi bi-people" viewBox="0 0 16 16">
                                        <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                                    </svg>
                                    <p class="text-sm font-bold">Jugadores (<%= jugadores.size() %>)</p>
                                </div>

                                <%--                        if length>2--%>

                                <%--                                                <% if (jugadores.size() > 3) { %>--%>
                                <%--                                                <button class="cursor-pointer hover:bg-violet-300 p-1 rounded-lg items-center">--%>
                                <%--                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="black"--%>
                                <%--                                                         class="bi bi-chevron-down w-3 h-3" viewBox="0 0 16 16">--%>
                                <%--                                                        <path fill-rule="evenodd"--%>
                                <%--                                                              d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/>--%>
                                <%--                                                    </svg>--%>
                                <%--                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="black"--%>
                                <%--                                                         class="bi bi-chevron-up hidden" viewBox="0 0 16 16">--%>
                                <%--                                                        <path fill-rule="evenodd"--%>
                                <%--                                                              d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707l-5.646 5.647a.5.5 0 0 1-.708-.708z"/>--%>
                                <%--                                                    </svg>--%>
                                <%--                                                </button>--%>
                                <%--                                                <% } %>--%>
                            </div>

                            <div>
                                <ul class="space-y-2 pl-6 initial-players overflow-auto" id="initial-players-<%= equipo.get("id") %>">
                                    <%
                                        for (JsonElement item : jugadores) {
                                            JsonObject jugador = item.getAsJsonObject();
                                    %>
                                    <li class="text-sm">
                                        <span class="font-medium text-xs"><%= jugador.get("nombre").getAsString() %> <%= jugador.get("apellido").getAsString() %></span>
                                        <span class="text-gray-500 text-xs ml-2">(<%= jugador.get("posicion").getAsString() %>)</span>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <%
                        }
                    }

                %>
            </div>


            <%--            <div class="w-full h-[92%] flex flex-col bg-white rounded-md px-2 py-2 gap-1 border-b border-violet-200">--%>
            <%--                <div class="w-full flex flex-col px-2 py-1 gap-2 bg-violet-100 rounded-md">--%>
            <%--                    <div class="w-full flex flex-row gap-2 border-b border-violet-200 px-2 py-1">--%>
            <%--                        <div class="w-[5rem] flex">--%>
            <%--                            <img src="https://img.freepik.com/vector-premium/ilustracion-logotipo-tenis-moderno-insignia_1344-435.jpg?w=1380"--%>
            <%--                                 alt="logo"/>--%>
            <%--                        </div>--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div class="w-full flex flex-row text-lg">--%>
            <%--                                <p class="font-bold">Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Deporte: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Ciudad: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Fecha Fundacion: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                    <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div>Jugadores</div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Nombre</div>--%>
            <%--                                <div>Apellido</div>--%>
            <%--                                <div>Posición</div>--%>
            <%--                            </div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Yuri</div>--%>
            <%--                                <div>Monroy</div>--%>
            <%--                                <div>Arco</div>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                </div>--%>

            <%--                <div class="w-full flex flex-col px-2 py-1 gap-2 bg-sky-100 rounded-md">--%>
            <%--                    <div class="w-full flex flex-row gap-2 border-b border-sky-200 px-2 py-1">--%>
            <%--                        <div class="w-[5rem] flex">--%>
            <%--                            <img src="https://img.freepik.com/vector-premium/ilustracion-logotipo-tenis-moderno-insignia_1344-435.jpg?w=1380"--%>
            <%--                                 alt="logo"/>--%>
            <%--                        </div>--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div class="w-full flex flex-row text-lg">--%>
            <%--                                <p class="font-bold">Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Deporte: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Ciudad: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Fecha Fundacion: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                    <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div>Jugadores</div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Nombre</div>--%>
            <%--                                <div>Apellido</div>--%>
            <%--                                <div>Posición</div>--%>
            <%--                            </div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Yuri</div>--%>
            <%--                                <div>Monroy</div>--%>
            <%--                                <div>Arco</div>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                </div>--%>
            <%--                <div class="w-full flex flex-col px-2 py-1 gap-2 bg-rose-100 rounded-md">--%>
            <%--                    <div class="w-full flex flex-row gap-2 border-b border-rose-200 px-2 py-1">--%>
            <%--                        <div class="w-[5rem] flex">--%>
            <%--                            <img src="https://img.freepik.com/vector-premium/ilustracion-logotipo-tenis-moderno-insignia_1344-435.jpg?w=1380"--%>
            <%--                                 alt="logo"/>--%>
            <%--                        </div>--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div class="w-full flex flex-row text-lg">--%>
            <%--                                <p class="font-bold">Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Deporte: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Ciudad: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                            <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                                <p class="font-bold">Fecha Fundacion: </p>--%>
            <%--                                <p>Yuriu</p>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                    <div class="w-full flex flex-row text-xs text-gray-600 gap-1">--%>
            <%--                        <div class="w-full flex flex-col">--%>
            <%--                            <div>Jugadores</div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Nombre</div>--%>
            <%--                                <div>Apellido</div>--%>
            <%--                                <div>Posición</div>--%>
            <%--                            </div>--%>
            <%--                            <div class="grid grid-cols-8">--%>
            <%--                                <div>Yuri</div>--%>
            <%--                                <div>Monroy</div>--%>
            <%--                                <div>Arco</div>--%>
            <%--                            </div>--%>
            <%--                        </div>--%>
            <%--                    </div>--%>
            <%--                </div>--%>

            <%--            </div>--%>

        </div>
        <%--                Paginacion--%>
        <div class="w-full h-[10%] flex flex-row px-2">
            <form method="get" action="equipos.jsp"
                  class="w-full h-full flex flex-row gap-3 px-10 justify-between bg-white border-t border-violet-200 items-center">
                <div class="flex flex-row gap-2 items-center">
                    <label class="text-gray-500">Items por pagina</label>
                    <select class="border border-violet-100 rounded-md px-2 py-1 outline-none" name="size" onchange="this.form.submit()">
                        <% for (int i = 1; i < 5; i++) { %>
                        <option value="<%= i %>" <%= (sizeData == i) ? "selected" : "" %> >
                            <%= i %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="flex flex-row gap-3 items-center">
                    <% int totalPages = dataEquipos.get("totalPages").getAsInt(); %>

                    <% if (pageData > 1) { %>
                    <div class="flex flex-row items-center text-gray-500 gap-1 border border-violet-100 px-2 py-1 rounded-md">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-left" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
                        </svg>
                        <button class="cursor-pointer" type="submit" name="page" value="<%= pageData - 1 %>">
                            Anterior
                        </button>
                    </div>
                    <% } %>

                    <div class="flex flex-row gap-1">
                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <button class="<%= (pageData == i) ? "bg-violet-500 text-white" : "bg-gray-300" %> px-2 py-1 rounded-lg"
                                name="page" type="submit cursor-pointer" value="<%= i %>"><%= i %>
                        </button>

                        <% } %>
                    </div>

                    <% if (pageData < totalPages) { %>
                    <div class="flex flex-row items-center text-gray-500 gap-1 border border-violet-100 px-2 py-1 rounded-md">
                        <button class="cursor-pointer" type="submit" name="page" value="<%= pageData + 1 %>">
                            Siguiente
                        </button>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-right" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
                        </svg>
                    </div>
                    <% } %>

                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
