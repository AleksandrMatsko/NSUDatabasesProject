package ru.nsu.ccfit.databases.matsko.library_fund.controllers.users;

import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories.*;

import java.util.Map;

public enum UserCategoryEnum {

    SCIENTIST("scientist") {
        @Override
        public BaseUserCategoryEntity  getExample(Map<String, Object> params) {
            if (params.containsKey("degree")) {
                ScientistEntity scientistEntity = new ScientistEntity();
                scientistEntity.setDegree((String) params.get("degree"));
                return scientistEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for scientist");
        }
    },

    WORKER("worker") {
        @Override
        public BaseUserCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("job") && params.containsKey("company")) {
                WorkerEntity workerEntity = new WorkerEntity();
                workerEntity.setJob((String) params.get("job"));
                workerEntity.setCompany((String) params.get("company"));
                return workerEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for worker");
        }
    },

    STUDENT("student") {
        @Override
        public BaseUserCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("university") && params.containsKey("faculty")) {
                StudentEntity studentEntity = new StudentEntity();
                studentEntity.setFaculty((String) params.get("faculty"));
                studentEntity.setUniversity((String) params.get("university"));
                return studentEntity;

            }
            throw new IllegalStateException("wrong amount of arguments for student");
        }
    },

    TEACHER("teacher") {
        @Override
        public BaseUserCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("subject") && params.containsKey("school")) {
                TeacherEntity teacherEntity = new TeacherEntity();
                teacherEntity.setSchool((String) params.get("school"));
                teacherEntity.setSubject((String) params.get("subject"));
                return teacherEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for teacher");
        }
    },

    PENSIONER("pensioner") {
        @Override
        public BaseUserCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("discount")) {
                PensionerEntity pensionerEntity = new PensionerEntity();
                pensionerEntity.setDiscount((Integer) params.get("discount"));
                return pensionerEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for pensioner");
        }
    },

    PUPIL("pupil") {
        @Override
        public BaseUserCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("school")) {
                PupilEntity pupilEntity = new PupilEntity();
                pupilEntity.setSchool((String) params.get("school"));
                return pupilEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for scientist");
        }
    };

    private final String categoryName;

    UserCategoryEnum(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public abstract BaseUserCategoryEntity getExample(Map<String, Object> params);
}
