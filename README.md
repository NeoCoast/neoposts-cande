# API Documentation

## POST api/auth/sign_in

- Params: None

- Body: Json containing valid user's email and password

- Headers: None

### Responses

- Success 200: renders the users data

```
{
  "data": {
    "email": "juan@mail.com",
    "provider": "email",
    "uid": "juan@mail.com",
    "id": 1,
    "first_name": "Juan",
    "last_name": "Lopez",
    "nickname": "juaan",
    "birthday": "2023-10-13"
  }
}
```

- Unauthorized 401: renders the following error

```
  {
    "success": false,
    "errors": [
      "Invalid login credentials. Please try again."
    ]
  }
```

## GET api/v1/users

- Params: None

- Body: None

- Headers: Bearer token, client and uid. uid is the user's email and bearer token and client can be retrieved from the headers of the response of signing in the user (/api/auth/sign_in)

### Responses

- Success 200: Renders all users with their ids, nicknames, first names, last names and birthdays in JSON format.

```
  [
    {
      "id": 1,
      "email": "juan@mail.com",
      "nickname": "juaaan",
      "first_name": "Juan",
      "last_name": "Lopez",
      "birthday": "2001-06-15"
    },

    {
      "id": 2,
      "email": "maria@mail.com",
      "nickname": "maria",
      "first_name": "Maria",
      "last_name": "Sanchez",
      "birthday": "1998-09-28"
    },

    {
      "id": 3,
      "email": "jose@mail.com",
      "nickname": "Jose",
      "first_name": "Jose",
      "last_name": "Perez",
      "birthday": "2002-10-21"
    },
  ]
```

- Unauthorized 401: renders the following error

```
  {
    "errors": [
      "You need to sign in or sign up before continuing."
    ]
  }
```
