# Описание API

### Authors

    /api/authors
        GET - получить всех авторов
        POST - в формате:
            {
                "lastName": "some_last_name",
                "firstName": "some_first_name",
                "patronymic": "some_patronymic"
            }
        добавление нового автора

### Books
    /api/books
        GET - получить все книги
        POST - в формате:
            {
                "name": "some_name",
                "literaryWorks": [1, 2]
            }
        добавление новой книги
    
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
        POST - в формате:
        {
            "lwName": "Война и мир. Том первый",
            "authors": [2],
            "categoryName": "novel",
            "categoryInfo": {
                "numberChapters": 25,
                "shortDesc": "первая часть знаменитого романа"
            }
        }
        добавляет новое литературное произведение

    /api/lws/popular
        required query params:
            - limit

### Librarians

    /api/librns
        GET - получить всех
        POST - в формате:
        {
            "lastName": "Книголюбов",
            "firstName": "Игорь",
            "patronymic": null,
            "hallId": 16,
            "dateHired": "2023-02-12",
            "dateRetired": null
        }
        добавление нового библиотекаря

    /api/librns
        required query params:
            - lib_name
            - hall

    /api/librns/report
        required query params:
            - start     // start date
            - end       // end date

### Libraries

    /api/libs
        GET - получение всех
        POST в формате:
        {
            "name": "Новосибирская областная юношеская библиотека",
            "district": "Центральный",
            "street": "Красный проспект",
            "building": "26",
            "numHalls": 2
        }
        добавление новой библиотеки

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
        POST - в формате:
        {
            "lastName": "some_last_name",
            "firstName": "some_first_name",
            "patronymic": "some_patronymic",
            "librarianId": 7,
            "categoryName": "pensioner",
            "categoryInfo": {
                "discount": 5
            }
        }
        добавление нового пользователя

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