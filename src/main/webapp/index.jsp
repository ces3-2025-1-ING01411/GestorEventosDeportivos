<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Estadisticas
    JsonObject estadisticas = RequestUtils.getJsonObjectFromUrl("http://localhost:8081/gestor-eventos-deportivos/estadisticas");
    //System.out.println(estadisticas);


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
        <div class="w-full h-[20%] bg-gray-100 flex text-center border-b border-violet-200 p-1 justify-center">
            <%-- <p class="text-lg sm:text-xl md:text-2xl font-bold">Gestor de Eventos Deportivos</p> --%>
            <img class="rounded-full" src="assets/logo.png"/>
        </div>
        <div class="flex flex-col w-full h-[80%] mt-10 px-2 gap-2">
            <a href="index.jsp">
                <div class="w-full flex py-2 px-3 text-violet-500 items-center bg-violet-100 rounded-md border border-violet-500 justify-between">
                    <p class="text-left sm:text-xs md:text-sm lg:text-base">
                        Estadisticas
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                        <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z"/>
                    </svg>
                </div>
            </a>
            <a href="eventos.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md px-3 py-2 justify-between">
                    <p class="text-gray-600 hover:text-violet-500 text-xs md:text-sm lg:text-base">
                        Eventos
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="oklch(0.446 0.03 256.802)" class="bi bi-calendar4-range" viewBox="0 0 16 16">
                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M2 2a1 1 0 0 0-1 1v1h14V3a1 1 0 0 0-1-1zm13 3H1v9a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
                        <path d="M9 7.5a.5.5 0 0 1 .5-.5H15v2H9.5a.5.5 0 0 1-.5-.5zm-2 3v1a.5.5 0 0 1-.5.5H1v-2h5.5a.5.5 0 0 1 .5.5"/>
                    </svg>
                </div>
            </a>
            <a href="equipos.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md px-3 py-2 justify-between">
                    <p class="text-gray-600 hover:text-violet-500 text-xs md:text-sm lg:text-base">
                        Equipos
                    </p>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="oklch(0.446 0.03 256.802)" class="bi bi-flag" viewBox="0 0 16 16">
                        <path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12 12 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A20 20 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a20 20 0 0 0 1.349-.476l.019-.007.004-.002h.001M14 1.221c-.22.078-.48.167-.766.255-.81.252-1.872.523-2.734.523-.886 0-1.592-.286-2.203-.534l-.008-.003C7.662 1.21 7.139 1 6.5 1c-.669 0-1.606.229-2.415.478A21 21 0 0 0 3 1.845v6.433c.22-.078.48-.167.766-.255C4.576 7.77 5.638 7.5 6.5 7.5c.847 0 1.548.28 2.158.525l.028.01C9.32 8.29 9.86 8.5 10.5 8.5c.668 0 1.606-.229 2.415-.478A21 21 0 0 0 14 7.655V1.222z"/>
                    </svg>
                </div>
            </a>
            <a href="jugadores.jsp">
                <div class="w-full flex items-center hover:bg-violet-100 rounded-md px-3 py-2 justify-between">
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