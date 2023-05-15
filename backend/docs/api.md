# Описание API

### Books
    /api/books
        GET: получить все книги
    
    /api/books/from_reg_lib
        required query params:
            - user_last_name
            - start     // start date
            - end       // end date

    /api/books/not_from_reg_lib
        required query params:
            - user_last_name
            - start     // start date
            - end       // end date

    /api/books/place
        required query params:
            - lib
            - hall
            - bookcase
            - shelf

    /api/books/{act}
        {act} can be:
            - receipt
            - dispose
        required query params:
            - start     // start date
            - end       // end date

### IssueJournal

    /api/ij

### LiteraryWorks

    /api/lws

    /api/lws/popular
        required query params:
            - limit

### Librarians

    /api/librns

    /api/librns
        required query params:
            - lib_name
            - hall

    /api/librns/report
        required query params:
            - start     // start date
            - end       // end date

### RegistrationJournal

    /api/rj

### StorageInfo

    /api/si
        optional query params (only one or none of all):
            - lwtmp
            - author    // last_name template

### Users

    /api/users
        optional query params (only one or none of all):
            - lwtmp
            - booktmp

    /api/users
        required query params:
            - lwtmp
            - start     // start date
            - end       // end date

    /api/users
        required query params:
            - librn_last_name
            - start     // start date
            - end       // end date

    /api/users/overdue

    /api/users/not_visit
        required query params:
            - start     // start date
            - end       // end date