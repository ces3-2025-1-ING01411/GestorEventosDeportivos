package co.edu.poli.ces3.gestoreventosdeportivos.dto;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;

public class JugadorBasico {
    private int id;
    private String nombre;
    private String apellido;
    private String posicion;

    public JugadorBasico(JugadorDAO jugador) {
        this.id = jugador.getId();
        this.nombre = jugador.getNombre();
        this.apellido = jugador.getApellido();
        this.posicion = jugador.getPosicion();
    }

    public int getId() {
        return id;
    }


    public String getNombre() {
        return nombre;
    }


    public String getApellido() {
        return apellido;
    }


    public String getPosicion() {
        return posicion;
    }

}
