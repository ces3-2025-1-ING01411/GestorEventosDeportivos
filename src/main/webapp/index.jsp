<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Estadisticas
    JsonObject estadisticas = RequestUtils.getJsonObjectFromUrl("http://localhost:8081/gestor-eventos-deportivos/estadisticas");
    System.out.println(estadisticas);


    //valores para graficas
    Double promedioJugadoresPorEquipo = estadisticas.get("promedioJugadoresPorEquipo").getAsDouble();
    JsonArray equiposConMasEventos = estadisticas.get("equiposConMasEventos").getAsJsonArray();

    //eventosPorDeporte
    List<String> deportesDeportesEventos = new ArrayList<>();
    List<Integer> eventosDeportesEventos = new ArrayList<>();
    JsonObject eventosPorDeporte = estadisticas.get("eventosPorDeporte").getAsJsonObject();
    for (Map.Entry<String, JsonElement> entry : eventosPorDeporte.entrySet()) {
        deportesDeportesEventos.add(entry.getKey());
        eventosDeportesEventos.add(entry.getValue().getAsInt());
    }

    //porcentajesEventos
    List<String> nombrePorcentajeEventos = new ArrayList<>();
    List<Double> porcentajeEventos = new ArrayList<>();
    JsonObject porcentajeOcupacionEvento = estadisticas.get("porcentajeOcupacionEvento").getAsJsonObject();
    for (Map.Entry<String, JsonElement> entryEvento : porcentajeOcupacionEvento.entrySet()) {
        nombrePorcentajeEventos.add(entryEvento.getKey());

        //Parsear string a double
        String porcentajeStr = entryEvento.getValue().getAsString().replace("%", "");
        ;
        double porcentajeNum = Double.parseDouble(porcentajeStr);

        porcentajeEventos.add(porcentajeNum);
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>GED</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <div class="w-full flex items-center bg-violet-100 rounded-md border border-violet-500">
                    <p class="px-8 py-2 text-violet-500">
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
            <div class="w-full h-full flex flex-col py-2 px-10 items-left justify-start bg-white border-b border-violet-200">
                <p class="text-xl font-bold">Estadisticas</p>
                <span class="text-xs font-thin text-gray-400">Información detallada de cada evento, con sus respectivos equipos.</span>
            </div>
        </div>

        <div class="w-full h-[90%] grid grid-cols-2 px-2 py-1 bg-gray-50 gap-2">
            <div class="w-full grid grid-rows-2 gap-2 h-full">
                <div class="w-full grid grid-cols-2 gap-2">
                    <div class="w-full bg-white rounded-lg shadow-lg overflow-hidden border border-violet-200 hover:shadow-xl transition-shadow duration-300 h-full flex flex-col items-center justify-center text-center p-2">
                        <div class="w-full h-[10%]">
                            <p class="titleGrafica px-2">Promedio de jugadores por equipo</p>
                        </div>
                        <div class="w-full h-[90%] flex flex-row justify-center items-center gap-2">
                            <div class="w-[50%] progress-value-circle items-center justify-center">
                                <span class="text-white" id="progress-value"><%= promedioJugadoresPorEquipo %></span>
                            </div>

                            <div class="w-[50%] progress-circle flex items-center justify-center">
                                <span id="progress-text">0%</span>
                            </div>
                                <script>
                                    const promedioJugadores = <%= promedioJugadoresPorEquipo %>;
                                    const porcentaje = promedioJugadores * 100; // Convierte a porcentaje
                                    const grados = promedioJugadores * 360; // Convierte a grados para CSS

                                    // Cambia el color del círculo según el valor
                                    document.querySelector(".progress-circle").style.background =
                                        `conic-gradient(#4f46e5 ${grados}deg, #e2e8f0 ${grados}deg)`;

                                    // Animación de conteo del porcentaje
                                    let contador = 0;
                                    const intervalo = setInterval(() => {
                                        document.getElementById("progress-text").innerText = contador + "%";
                                        if (contador >= porcentaje) {
                                            clearInterval(intervalo);
                                        }
                                        contador++;
                                    }, 15);
                                </script>
                        </div>

                    </div>

                    <div class="bg-white rounded-lg shadow-lg overflow-hidden border border-violet-200 hover:shadow-xl transition-shadow duration-300 h-full">
                        <canvas id="porcentajeOcupacionEventoChart"></canvas>
                        <script>
                            var ctx = document.getElementById('porcentajeOcupacionEventoChart').getContext('2d');

                            <%
                                Gson gson = new Gson();
                                String nombresJson = gson.toJson(nombrePorcentajeEventos);
                                String porcentajesJson = gson.toJson(porcentajeEventos);
                            %>

                            //obtener los datos en js
                            var nombresEventos = <%= nombresJson %>;
                            var porcentajesEventos = <%= porcentajesJson %>;

                            var porcentajeOcupacionEventoChar = new Chart(ctx, {
                                type: 'doughnut',
                                data: {
                                    labels: nombresEventos,  // Usa las etiquetas correctas
                                    datasets: [{
                                        label: 'Ocupación por Evento',
                                        data: porcentajesEventos, // Usa los valores correctos
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.5)',
                                            'rgba(255, 159, 64, 0.5)',
                                            'rgba(255, 205, 86, 0.5)',
                                            'rgba(75, 192, 192, 0.5)',
                                            'rgba(54, 162, 235, 0.5)'
                                        ]
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: {
                                        title: {
                                            display: true,
                                            text: 'Porcentaje de Ocupación de cada Evento'
                                        }
                                    }
                                }
                            });
                        </script>
                    </div>
                </div>

                <div class="py-1 w-full bg-white rounded-lg shadow-lg overflow-hidden border border-violet-200 hover:shadow-xl transition-shadow duration-300 h-full">
                    <p class="titleGrafica px-2">Equipos con más eventos programados</p>
                    <div class="h-[90%] w-full flex flex-col rounded-md px-2 py-2 gap-1">
                        <%-- Encabezado --%>
                        <div class="w-full h-[7.5vh] grid grid-cols-5 bg-violet-100 rounded-md px-1 gap-2 items-center text-sm border border-violet-200">
                            <div class="text-sm border-r border-violet-300">Logo</div>
                            <div class="border-r border-violet-300">Equipo</div>
                            <div class="border-r border-violet-300">Deporte</div>
                            <div class="border-r border-violet-300">Ciudad</div>
                            <div class="border-violet-300">Fecha Fundacion</div>
                        </div>

                        <%-- Cuerpo de la tabla --%>
                        <%
                            if (equiposConMasEventos.size() > 0) {
                                for (JsonElement registro : equiposConMasEventos) {
                                    JsonObject equipo = registro.getAsJsonObject();
                        %>
                        <div class="w-full grid grid-cols-5 bg-gray-50 rounded-md px-1 gap-2 items-center text-xs overflow-auto border border-violet-200">
                            <div class="p-1">
                                <img class="w-10 h-10 rounded-md" src="<%= equipo.get("logo").getAsString() %>" alt="logo"/>
                            </div>
                            <div class="text-gray-700"><%= equipo.get("nombre").getAsString() %>
                            </div>
                            <div class="text-gray-700"><%= equipo.get("deporte").getAsString() %>
                            </div>
                            <div class="text-gray-700"><%= equipo.get("ciudad").getAsString() %>
                            </div>
                            <div class="text-gray-700"><%= equipo.get("fechaFundacion").getAsString() %>
                            </div>
                            <%--                            <div class="flex gap-1">--%>
                            <%--                                <%--%>
                            <%--                                    JsonArray jsonJugadores = equipo.get("jugadores").getAsJsonArray();--%>
                            <%--                                    for (int i = 0; i < jsonJugadores.size(); i++) {--%>
                            <%--                                %>--%>
                            <%--                                <div class="bg-violet-200 px-1 rounded-md text-gray-700"><%= jsonJugadores.get(i).getAsString() %>--%>
                            <%--                                </div>--%>
                            <%--                                <%--%>
                            <%--                                    }--%>
                            <%--                                %>--%>
                            <%--                            </div>--%>
                        </div>

                        <% }
                        } else {
                        %>
                        <div class="w-full h-[5vh] flex justify-center bg-gray-50 rounded-md px-1 gap-2 items-center text-xs">
                            <div class="flex text-gray-700 items-center text-center">No hay equipos.</div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="h-full bg-white rounded-lg shadow-lg overflow-hidden border border-violet-200 hover:shadow-xl transition-shadow duration-300">
                <canvas id="eventosPorDeporteChart"></canvas>
                <script>
                    var ctx = document.getElementById('eventosPorDeporteChart').getContext('2d');

                    <%

                        String deportesJson = gson.toJson(deportesDeportesEventos);
                        String eventosJson = gson.toJson(eventosDeportesEventos);
                    %>


                    //obtener los datos en js
                    var deportesDeportesEventos = <%= deportesJson %>;
                    var eventosDeportesEventos = <%= eventosJson %>;

                    var eventosPorDeporteChart = new Chart(ctx, {
                        type: 'pie',
                        data: {
                            labels: deportesDeportesEventos,  // Usa las etiquetas correctas
                            datasets: [{
                                label: 'Eventos por Deporte',
                                data: eventosDeportesEventos, // Usa los valores correctos
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.5)',  // Morado
                                    'rgba(201, 203, 207, 0.5)',  // Gris
                                    'rgba(255, 87, 34, 0.5)',    // Naranja oscuro
                                    'rgba(0, 188, 212, 0.5)',    // Cian
                                    'rgba(139, 195, 74, 0.5)'
                                ]
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                title: {
                                    display: true,
                                    text: 'Cantidad de Eventos por Deporte'
                                }
                            }
                        }
                    });
                </script>
            </div>
        </div>
    </div>
</div>
</body>
</html>