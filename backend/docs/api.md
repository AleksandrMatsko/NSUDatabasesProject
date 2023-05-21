# Описание API

### Authors

    /api/authors
        GET - получить всех авторов
        POST в формате:
        {
            "lastName": "some_last_name",
            "firstName": "some_first_name",
            "patronymic": "some_patronymic"
        } - добавление нового автора

    /api/authors/2
        PUT в формате (AuthorEntity) (число в path - id автора):
        {
            "authorId": 2,
            "lastName": "Толстой",
            "firstName": "Лев",
            "patronymic": "Николаевич",
            "literaryWorks": [
                {
                    "lwId": 36,
                    "name": "Война и мир. Том второй"
                },
                {
                    "lwId": 34,
                    "name": "Война и мир. Том первый"
                },
                {
                    "lwId": 37
                }
            ]
        } - обновление автора

### Books
    /api/books
        GET - получить все книги
        POST в формате:
        {
            "name": "some_name",
            "literaryWorks": [1, 2]
        } - добавление новой книги
        PUT в формате:
        {
            "bookId": 21,
            "name": "Война и мир.",
            "literaryWorks": [
                {
                    "lwId": 37,
                    "name": "Война и мир. Том третий"
                },
                {
                    "lwId": 34
                },
                {
                    "lwId": 36
                }
            ]
        } - Обновление книги
    
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
        GET - получить все
        POST - в формате:
        {
            "storedId": 1,
            "userId": 9,
            "dateIssue": "2022-10-20",
            "dateReturn": "2022-10-30",
            "issuedBy": 1,
            "acceptedBy": 6
        } - добавление новой записи в журнал выдачи

### LiteraryWorks

    /api/lws
        GET - получить все
        POST в формате:
        {
            "lwName": "Война и мир. Том третий",
            "authors": [2],
            "categoryName": "novel",
            "categoryInfo": {
                "numberChapters": 96,
                "shortDesc": "третья часть знаменитого романа"
            }
        } - добавляет новое литературное произведение

    /api/lws/popular
        required query params:
            - limit

### Librarians

    /api/librns
        GET - получить всех
        POST в формате:
        {
            "lastName": "Книголюбов",
            "firstName": "Игорь",
            "patronymic": null,
            "hallId": 16,
            "dateHired": "2023-02-12",
            "dateRetired": null
        } - добавление нового библиотекаря

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
        POST - в формате:
        {
            "bookId": 20,
            "hallId": 16,
            "bookcase": 1,
            "shelf": 1,
            "availableIssue": "true",
            "durationIssue": 14,
            "dateReceipt": "2012-01-29",
            "dateDispose": null
        }
        добавление нового физического экземпляра

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