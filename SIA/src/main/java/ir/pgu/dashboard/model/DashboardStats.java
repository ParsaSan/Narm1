package ir.pgu.dashboard.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardStats {

    private long totalCourses;
    private long totalFiles;
    private long totalStudents;
}