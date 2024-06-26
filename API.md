# API

## Seeded data

This app has some seeded data.
Consider this when performing requests.
To login as a Member, use this credential:

```shell
email: 'leoma_waelchi@reynolds.test', password: '1Owsn9BUDSuzr4g'
```

To login as a Librarian, use this credential:
```shell
email: 'blair.marks@russel-howell.example', password: 'N4raOMHAjL7HG'
```

## Endpoints

[Authentication](#authentication)

- [SIGNUP](#post-signup)
- [LOGIN](#post-login)
- [LOGOUT](#delete-logout)

[Books](#books)

- [INDEX](#get-books)
- [CREATE](#post-books)
- [UPDATE](#patch-booksid)
- [SEARCH](#get-search)
- [DELETE](#delete-booksid)

[BookBorrows](#bookborrows)

- [CREATE](#post-book_borrows)
- [UPDATE](#patch-book_borrowsid)

[Dashboard](#dashboard)

- [INDEX](#get-dashboard)

## Authentication

### POST /signup

Create a new user in the application.

```shell
curl --location 'http://localhost:3000/signup' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": {
    "email": "test@test.com",
    "password": "password"
  }
}'
```

Example response:

Status code: 200 - OK

```json
{
    "status": {
        "code": 200,
        "message": "Signed up successfully."
    },
    "data": {
        "id": 3,
        "email": "tesasdasdasdsaddt@test.com",
        "role": "member",
        "created_at": "2024-06-26T12:13:17.512Z"
    }
}
```

### POST /login

Performs the login into the API.

Running with cURL:

```shell
curl --location 'http://localhost:3000/login' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": {
    "email": "leoma_waelchi@reynolds.test",
    "password": "1Owsn9BUDSuzr4g"
  }
}'
```

Example response:

Status code: 200 - OK

```json
{
    "status": {
        "code": 200,
        "message": "Logged in successfully."
    },
    "data": {
        "id": 1,
        "email": "leoma_waelchi@reynolds.test",
        "role": "member",
        "created_at": "2024-06-26T03:02:13.144Z"
    }
}
```

Now copy the Authorization field from the response, it should look like this:
```
Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiINjE2NGY5Zi02NjhmLTQ1MmUtOTI4OS04MGY0NTFkNTY0NzkiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzNzQzLCJleHAiOjE3MTk0MDU1NDN9.K0uye0BQjnhlkVVKGikcxyvpXaCsqk5UaSYU35r9OIg
```

### DELETE /logout

Delete current session

Running with cURL:

```shell
curl --location --request DELETE 'http://localhost:3000/logout' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJjNWI2Mzk2Mi00NjkzLTQ0NTEtYThiMS0yMTU0MmI3MjZhMmQiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzOTMyLCJleHAiOjE3MTk0MDU3MzJ9.SusgXTlZbYSvlmB5pB_Pu8WpzNk3WhtG3wcuRCprFVE'
```

Example response:

Status code: 200 - OK

```json
{
    "status": 200,
    "message": "logged out successfully"
}
```

### GET /current_user

Returns data from the current user.

Running with cURL:

```shell
curl --location 'http://localhost:3000/current_user' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwMmFhYmMxNC1jMTkyLTQ2MDItYmJmNS00NzU2ZGVhNzY4NDciLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzOTk3LCJleHAiOjE3MTk0MDU3OTd9.hbDiV_LoRHcVAa0osi3Q7Cfa4MlGUMssS2nRHTKlnT0'
```

Example response:

Status code: 200 - OK

```json
{
  "id": 3,
  "email": "test@test.com",
  "role": "member",
  "created_at": "2024-06-26T12:13:17.512Z"
}
```

## Books

### GET /books

Creates a new Book

Running with cURL:

```shell
curl --location 'http://localhost:3000/books' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwMmFhYmMxNC1jMTkyLTQ2MDItYmJmNS00NzU2ZGVhNzY4NDciLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzOTk3LCJleHAiOjE3MTk0MDU3OTd9.hbDiV_LoRHcVAa0osi3Q7Cfa4MlGUMssS2nRHTKlnT0'
```

Example response:

```json
[
    {
        "id": 1,
        "title": "Frequent Hearses",
        "genre": "Crime/Detective",
        "isbn": "966677850-5",
        "author": "Agatha Christie",
        "copies": 10,
        "created_at": "2024-06-26T03:02:12.935Z"
    },
    {
        "id": 2,
        "title": "Those Barren Leaves, Thrones, Dominations",
        "genre": "Reference book",
        "isbn": "725199056-3",
        "author": "Ricarda Kuhic IV",
        "copies": 10,
        "created_at": "2024-06-26T03:02:12.939Z"
    }
]
```

### GET /search

Search the Books

Running with cURL:

```shell
curl --location 'http://localhost:3000/books/search?by_title=frequen' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwMmFhYmMxNC1jMTkyLTQ2MDItYmJmNS00NzU2ZGVhNzY4NDciLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzOTk3LCJleHAiOjE3MTk0MDU3OTd9.hbDiV_LoRHcVAa0osi3Q7Cfa4MlGUMssS2nRHTKlnT0'
```

Example response:

```json
[
  {
    "id": 1,
    "title": "Frequent Hearses",
    "genre": "Crime/Detective",
    "isbn": "966677850-5",
    "author": "Agatha Christie",
    "copies": 10,
    "created_at": "2024-06-26T03:02:12.935Z"
  }
]
```

Available query params: `by_author, by_genre, by_title`

### POST /books

Creates a new Book

Running with cURL:

```shell
curl --location 'http://localhost:3000/books/' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwMmFhYmMxNC1jMTkyLTQ2MDItYmJmNS00NzU2ZGVhNzY4NDciLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDAzOTk3LCJleHAiOjE3MTk0MDU3OTd9.hbDiV_LoRHcVAa0osi3Q7Cfa4MlGUMssS2nRHTKlnT0' \
--header 'Content-Type: application/json' \
--data '{
  "book": {
    "copies": 10,
    "author": "Barton Okuneva",
    "title": "The Parliament of Man",
    "genre": "Horror",
    "isbn": "490031211-8"
  }
}'
```

Example response, when user is a Member:

Status code: 401 - Unauthorized

```json
{
  "error": "not authorized to perform this action"
}
```

Example response, when user is a Librarian:

Status code: 201 - Created
```json
{
  "id": 3,
  "title": "The Parliament of Man",
  "genre": "Horror",
  "isbn": "490031211-8",
  "author": "Barton Okuneva",
  "copies": 10,
  "created_at": "2024-06-26T12:23:57.865Z"
}
```

### PATCH /books/:id

Updates a Book

Running with cURL:

```shell
curl --location --request PATCH 'http://localhost:3000/books/3/' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3NGNlMGU1NC0xMTY4LTQ0ZjgtYjExNS05OGMxMDJiNTIwYzYiLCJzdWIiOiIyIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDA0NjIyLCJleHAiOjE3MTk0MDY0MjJ9.eGsa0g10xBPHof32x-fmXDhu4fRcbsRakWy7sHdmNHc' \
--header 'Content-Type: application/json' \
--data '{
  "book": {
    "title": "The Parliament of People"
  }
}'
```

#### Example response, when user is a Member:

Status code: 401 - Unauthorized

```json
{
  "error": "not authorized to perform this action"
}
```

#### Example response, when user is a Librarian:

Status code: 200 - OK
```json
{
  "id": 3,
  "title": "The Parliament of People",
  "genre": "Horror",
  "isbn": "490031211-8",
  "author": "Barton Okuneva",
  "copies": 10,
  "created_at": "2024-06-26T12:23:57.865Z"
}
```

#### Example response, when user is a Librarian but resource does not exist:

Status code: 401 - Unauthorized

```json
{
  "error": "not-found"
}
```

### DELETE /books/:id

Deletes a Book

Running with cURL:

```shell
curl --location --request DELETE 'http://localhost:3000/books/3/' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3NGNlMGU1NC0xMTY4LTQ0ZjgtYjExNS05OGMxMDJiNTIwYzYiLCJzdWIiOiIyIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDA0NjIyLCJleHAiOjE3MTk0MDY0MjJ9.eGsa0g10xBPHof32x-fmXDhu4fRcbsRakWy7sHdmNHc'
```

#### Example response, when user is a Member:

Status code: 401 - Unauthorized

```json
{
  "error": "not authorized to perform this action"
}
```

#### Example response, when user is a Librarian:

Status code: 204 - No content

#### Example response, when user is a Librarian but resource does not exist:

Status code: 401 - Unauthorized

```json
{
  "error": "not-found"
}
```

## BookBorrows

### POST /book_borrows

Creates a new BookBorrow

Running with cURL:

```shell
curl --location 'http://localhost:3000/book_borrows' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlZGI5MmZiMy05N2IyLTQyOTgtOTc4Yy04NWNmNzRmZGEzNDIiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDA1MzQ0LCJleHAiOjE3MTk0MDcxNDR9.-cgISTbWabEhTv29EwH0pPLStPh5kIMAsKhictW9f7I' \
--header 'Content-Type: application/json' \
--data '{
  "book_borrow": {
    "user_id": 1,
    "book_id": 4,
    "due_date": "10-07-2024",
    "start_date": "26-06-2024"
  }
}'
```

#### Example response, when user is a Member:

Status code: 201 - Created

```json
{
  "id": 3,
  "book_id": 4,
  "returned": false,
  "user_id": 1,
  "start_date": "26/06/2024",
  "due_date": "10/07/2024"
}
```

#### Example response, when user is a Librarian:

Status code: 201 - Created

```json
{
  "id": 3,
  "book_id": 4,
  "returned": false,
  "user_id": 1,
  "start_date": "26/06/2024",
  "due_date": "10/07/2024"
}
```

### PATCH /book_borrows/:id

Updates a Book

Running with cURL:

```shell
curl --location --request PATCH 'http://localhost:3000/book_borrows/3' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlZGI5MmZiMy05N2IyLTQyOTgtOTc4Yy04NWNmNzRmZGEzNDIiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDA1MzQ0LCJleHAiOjE3MTk0MDcxNDR9.-cgISTbWabEhTv29EwH0pPLStPh5kIMAsKhictW9f7I' \
--header 'Content-Type: application/json' \
--data '{
  "book_borrow": {
    "returned": true
  }
}'
```

#### Example response, when user is a Member:

Status code: 401 - Unauthorized

```json
{
  "error": "not authorized to perform this action"
}
```

#### Example response, when user is a Librarian:

Status code: 200 - OK
```json
{
  "id": 3,
  "book_id": 4,
  "returned": true,
  "user_id": 1,
  "start_date": "26/06/2024",
  "due_date": "10/07/2024"
}
```

#### Example response, when user is a Librarian but resource does not exist:

Status code: 401 - Unauthorized

```json
{
  "error": "not-found"
}
```

## Dashboard

### GET /dashboard

Returns all necessary info for the dashboard

Running with cURL:

```shell
curl --location 'http://localhost:3000/dashboard' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3NGNlMGU1NC0xMTY4LTQ0ZjgtYjExNS05OGMxMDJiNTIwYzYiLCJzdWIiOiIyIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzE5NDA0NjIyLCJleHAiOjE3MTk0MDY0MjJ9.eGsa0g10xBPHof32x-fmXDhu4fRcbsRakWy7sHdmNHc'
```

#### Example response, when user is a Member:

Status code: 200 - OK

```json
{
  "book_borrows": [
    {
      "id": 1,
      "user_id": 1,
      "book_id": 1,
      "start_date": "11/06/2024",
      "due_date": "25/06/2024",
      "returned": false,
      "book": {
        "id": 1,
        "author": "Agatha Christie",
        "title": "Frequent Hearses",
        "genre": "Crime/Detective",
        "isbn": "966677850-5"
      }
    },
    {
      "id": 2,
      "user_id": 1,
      "book_id": 2,
      "start_date": "12/06/2024",
      "due_date": "26/06/2024",
      "returned": false,
      "book": {
        "id": 2,
        "author": "Ricarda Kuhic IV",
        "title": "Those Barren Leaves, Thrones, Dominations",
        "genre": "Reference book",
        "isbn": "725199056-3"
      }
    }
  ],
  "overdue_borrows": [
    {
      "id": 1,
      "user_id": 1,
      "book_id": 1,
      "start_date": "11/06/2024",
      "due_date": "25/06/2024",
      "returned": false,
      "book": {
        "id": 1,
        "author": "Agatha Christie",
        "title": "Frequent Hearses",
        "genre": "Crime/Detective",
        "isbn": "966677850-5"
      }
    }
  ]
}
```

#### Example response, when user is a Librarian:

Status code: 200 - OK

```json
{
  "total_books": 2,
  "total_borrowed": 2,
  "borrowed_due_today": [
    {
      "id": 2,
      "user_id": 1,
      "book_id": 2,
      "start_date": "12/06/2024",
      "due_date": "26/06/2024",
      "returned": false,
      "book": {
        "id": 2,
        "author": "Ricarda Kuhic IV",
        "title": "Those Barren Leaves, Thrones, Dominations",
        "genre": "Reference book",
        "isbn": "725199056-3"
      }
    }
  ],
  "users_with_overdue_books": [
    {
      "email": "leoma_waelchi@reynolds.test"
    }
  ]
}
```
