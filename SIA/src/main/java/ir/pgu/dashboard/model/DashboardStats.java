package ir.pgu.dashboard.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardStats {

    private int currentTerm;
    private int passedUnits;
    private int currentTermUnits;
    private int currentTermCoursesCount;
    private String gpaTrend;
    private List<Double> pastTermGpas;
}