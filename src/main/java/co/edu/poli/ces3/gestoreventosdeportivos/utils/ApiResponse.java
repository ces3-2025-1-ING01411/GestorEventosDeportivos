package co.edu.poli.ces3.gestoreventosdeportivos.utils;

public class ApiResponse {

    private String status;
    private String message;

    public ApiResponse(String status, String message) {
        this.status = status;
        this.message = message;
    }

    public String getStatus() {
        return status;
    }
    public String getMessage() {
        return message;
    }
}
