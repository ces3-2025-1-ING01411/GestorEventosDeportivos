package co.edu.poli.ces3.gestoreventosdeportivos.utils;

import java.util.List;

public class SuccessResponse {
    private int page;
    private int size;
    private int totalData;
    private int totalPages;
    private List data;

    public SuccessResponse(int page, int size, int totalData, int totalPages, List data) {
        this.page = page;
        this.size = size;
        this.totalData = totalData;
        this.totalPages = totalPages;
        this.data = data;
    }

    public int getPage() {
        return page;
    }

    public int getSize() {
        return size;
    }

    public int getTotalData() {
        return totalData;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public List getData() {
        return data;
    }
}
