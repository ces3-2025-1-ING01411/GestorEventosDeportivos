package co.edu.poli.ces3.gestoreventosdeportivos.servlet;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.UniqueIDGenerator;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Stack;

@WebListener
    public class AppInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Inicializando datos de la aplicación..");

        Stack<EquipoDAO> equipos = new Stack<>();
        Stack<JugadorDAO> jugadores = new Stack<>();
        Stack<EventoDAO> eventos = new Stack<>();

        //inicializarr jugaodres
        JugadorDAO jg1 = new JugadorDAO(
                "Yuri",
                "Monroy",
                "2004-03-26",
                "Colombiana",
                "Arco",
                7,
                2,
                true
        );
        jg1.setId(UniqueIDGenerator.generateJugadorID());
        jugadores.push(jg1);

        JugadorDAO jg2 = new JugadorDAO(
                "Luis",
                "Vargas",
                "1975-09-28",
                "Colombiana",
                "Prin",
                1,
                1,
                true
        );
        jg2.setId(UniqueIDGenerator.generateJugadorID());
        jugadores.push(jg2);

        //inicializar eqqipos
        EquipoDAO eq1 = new EquipoDAO(
                "MEXQ",
                "Baloncesto",
                "Sabaneta",
                "2021-10-04",
                "https://th.bing.com/th/id/OIP.v4c2phZ4_TPf7y7vCwPb6gHaHa?rs=1&pid=ImgDetMain",
                new Stack<>()
        );
        eq1.setId(UniqueIDGenerator.generateEquipoID());
        eq1.agregarJugador(2);
        equipos.push(eq1);

        //        Stack<Integer> jugadoresEq2 = new Stack<>();
//        jugadoresEq2.push(1);
        EquipoDAO eq2 = new EquipoDAO(
                "WIFMD",
                "Futbol",
                "Medellin",
                "2018-12-24",
                "https://th.bing.com/th/id/OIP.YsBuyHy-ZYwoAM2f-cONgwHaIS?rs=1&pid=ImgDetMain",
                new Stack<>()
        );
        eq2.setId(UniqueIDGenerator.generateEquipoID());
        eq2.agregarJugador(1);
        equipos.push(eq2);

//        Stack<Integer> jugadoresEq3 = new Stack<>();
//        jugadoresEq3.push(1);
        EquipoDAO eq3 = new EquipoDAO(
                "QSVF",
                "Tenis",
                "Bello",
                "2014-03-16",
                "https://img.freepik.com/vector-premium/ilustracion-logotipo-tenis-moderno-insignia_1344-435.jpg?w=1380",
                new Stack<>()
        );
        eq3.setId(UniqueIDGenerator.generateEquipoID());
        eq3.agregarJugador(1);
        equipos.push(eq3);


        //inicializar eventos
        EventoDAO ev1 = new EventoDAO(
                "Evento1",
                "2025-03-26",
                "Parque principal de Sabaneta",
                "Baloncesto",
                new Stack<>(),
                20,
                5,
                "Programado"
        );
        ev1.setId(UniqueIDGenerator.generateEventoID());
        ev1.agregarEquiposParticipantes(1);
        ev1.agregarEquiposParticipantes(2);
        eventos.push(ev1);

        EventoDAO ev2 = new EventoDAO(
                "Evento2",
                "2025-03-25",
                "Parque principal de Itagui",
                "Futbol",
                new Stack<>(),
                50,
                10,
                "Programado"
        );
        ev2.setId(UniqueIDGenerator.generateEventoID());
        ev2.agregarEquiposParticipantes(2);
        ev2.agregarEquiposParticipantes(3);
        eventos.push(ev2);



        // guardar datos en el contexto de la aplicacion
        ServletContext context = sce.getServletContext();
        context.setAttribute("jugadores", jugadores);
        context.setAttribute("equipos", equipos);
        context.setAttribute("eventos", eventos);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Aplicacion cerrada.");
    }
}
