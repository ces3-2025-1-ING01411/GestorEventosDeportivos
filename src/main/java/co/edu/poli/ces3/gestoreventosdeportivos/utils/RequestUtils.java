package co.edu.poli.ces3.gestoreventosdeportivos.utils;

import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class RequestUtils {

    public static JsonObject getParamsFromBody(HttpServletRequest request) throws ServletException, IOException {
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line = reader.readLine();
        while (line != null) {
            sb.append(line + "\n");
            line = reader.readLine();
        }
        reader.close();
        return JsonParser.parseString(sb.toString()).getAsJsonObject();
    }

    public static void sendJsonResponse(HttpServletResponse response, int statusCode, Object responseObject) throws IOException {
        response.setContentType("application/json");
        response.setStatus(statusCode);
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.println(gson.toJson(responseObject));
        out.flush();
    }

    public static boolean isInteger(JsonElement element) {
        if (!element.isJsonPrimitive() || !element.getAsJsonPrimitive().isNumber()) {
            return false;
        }
        try {
            element.getAsInt();  // Esto lanza una excepción si el número no es entero
            return true;
        } catch (NumberFormatException e) {
            return false;

        }
    }

    public static boolean isBoolean(JsonElement element) {
        return element.isJsonPrimitive() && element.getAsJsonPrimitive().isBoolean();
    }

    public static boolean validateParams(HttpServletResponse response, String param, String errorMessage) throws ServletException, IOException {
        if (param == null || param.trim().isEmpty()) {
            RequestUtils.sendJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error", errorMessage)
            );
            return false;
        }
        return true;
    }

    public static JsonArray getJsonArrayFromUrl(String urlString) {
        JsonArray jsonArray = new JsonArray();
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();
                jsonArray = JsonParser.parseString(response.toString()).getAsJsonArray();
            }
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("Error en la solicitud GET: " + e.getMessage());
        }
        return jsonArray;
    }

    public static JsonObject getJsonObjectFromUrl(String urlString) {
        JsonObject jsonObject = new JsonObject();
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();
                jsonObject = JsonParser.parseString(response.toString()).getAsJsonObject();
            }
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("Error en la solicitud GET: " + e.getMessage());
        }
        return jsonObject;
    }

    public static JsonObject sendPostRequest(String urlString, JsonObject data) {
        JsonObject jsonObject = new JsonObject();
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true); // Habilita el envío de datos

            // Escribe el JSON en la solicitud
            OutputStream os = conn.getOutputStream();
            OutputStreamWriter osw = new OutputStreamWriter(os, "UTF-8");
            osw.write(data.toString());
            osw.flush();
            osw.close();
            os.close();

            // Leer la respuesta del servidor
            if (conn.getResponseCode() == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();
                jsonObject = JsonParser.parseString(response.toString()).getAsJsonObject();
            }
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("Error en la solicitud POST: " + e.getMessage());
        }
        return jsonObject;
    }

}
