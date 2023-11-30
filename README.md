# API Documentation

## GET api/v1/users

- Params: None

- Body: None

- Headers: Bearer token, client and uid. uid is users email and bearer token and client can be retrieved from the headers of the response of signing in the user (/api/auth/sign_in)

### Responses

- Success 200: Renders all users with their ids, nicknames, first names, last names and birthdays in JSON format.

  [
  {
  "id": 1,
  "email": "juan@mail.com",
  "nickname": "juan",
  "first_name": "juan",
  "last_name": "lopez",
  "birthday": "2001-06-15"
  },
  {
  "id": 2,
  "email": "maria@mail.com",
  "nickname": "maria",
  "first_name": "maria",
  "last_name": "sanchez",
  "birthday": "1998-09-28"
  },
  {
  "id": 3,
  "email": "jose@mail.com",
  "nickname": "jose",
  "first_name": "jose",
  "last_name": "perez",
  "birthday": "2002-10-21"
  },
  ]

- Unauthorized 401:
  {
  "errors": [
  "You need to sign in or sign up before continuing."
  ]
  }
