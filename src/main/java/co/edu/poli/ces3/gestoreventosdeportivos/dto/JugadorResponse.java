package co.edu.poli.ces3.gestoreventosdeportivos.dto;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;

public class JugadorResponse {
    private int id;
    private String nombre;
    private String apellido;
    private String fechaNacimiento;
    private String nacionalidad;
    private String posicion;
    private int numero;
    private int equipoId;
    private boolean estadoActivo;
    private String equipoNombre;

    public JugadorResponse(JugadorDAO jugador, String equipoNombre) {
        this.id = jugador.getId();
        this.nombre = jugador.getNombre();
        this.apellido = jugador.getApellido();
        this.fechaNacimiento = jugador.getFechaNacimiento();
        this.nacionalidad = jugador.getNacionalidad();
        this.posicion = jugador.getPosicion();
        this.numero = jugador.getNumero();
        this.equipoId = jugador.getEquipoId();
        this.estadoActivo = jugador.isEstadoActivo();
        this.equipoNombre = equipoNombre;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public void setFechaNacimiento(String fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public void setNacionalidad(String nacionalidad) {
        this.nacionalidad = nacionalidad;
    }

    public void setPosicion(String posicion) {
        this.posicion = posicion;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public void setEquipoId(int equipoId) {
        this.equipoId = equipoId;
    }

    public void setEstadoActivo(boolean estadoActivo) {
        this.estadoActivo = estadoActivo;
    }

    public void setEquipoNombre(String equipoNombre) {
        this.equipoNombre = equipoNombre;
    }
}
