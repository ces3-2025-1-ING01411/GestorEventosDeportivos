package co.edu.poli.ces3.gestoreventosdeportivos.utils;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

public class UniqueIDGenerator {
    private static final AtomicInteger counterEquipo = new AtomicInteger(1);
    private static final AtomicInteger counterJugador = new AtomicInteger(1);
    private static final AtomicInteger counterEvento = new AtomicInteger(1);

    public static int generateEquipoID() {
        return counterEquipo.getAndIncrement();
    }

    public static int generateJugadorID() {
        return counterJugador.getAndIncrement();
    }
    public static int generateEventoID() {
        return counterEvento.getAndIncrement();
    }
}
