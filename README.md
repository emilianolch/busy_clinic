# Busy Clinic

This is a simple Rails API to manage doctor availabilities and patient appointments.

## Notes

- The authentication process is out of the scope of this solution. The API assumes that the user is already authenticated and that the token is passed in the `Authorization` header.
- To keep it simple, the database engine is SQLite. In a real world scenario, I would use PostgreSQL.
- The JSON responses are generated using jbuilder. In a real world scenario, where performance is an issue, I would use jsonapi-serializer.
- The code is linted using Rubocop with a set of rules that I use in my daily work.
- All the code is covered by Rspec tests, following the TDD approach.
- The API is not versioned. In a real world scenario, I would wrap the API in a namespace and version it.

## Installation

Install the dependencies:

`bundle install`

Create the database and run the migrations:

`rails db:setup`

The database is seeded with two doctors with a 6 hour schedule each, and a patient.
The patient's token will be printed to the console. Use this token as the `Authorization` header for all requests.

Run the tests:

`bundle exec rspec`

Start the server:

`rails s`

## Models

### User

The user model is used to represent both doctors and patients, using single table inheritance. It has a `token` attribute that is used for authentication.

### Doctor

The doctor model has a `has_many` relationship with the `Slot` model. The schedule of a doctor is composed of a list of fixed-length time slots. The `#generate_slots` method is provided to generate the slots for a given time range.

A doctor has a `has_many` relationship with the `Appointment` model through the `Slot` model, which is used to retrieve the list of appointments for a doctor.
It also has a `has_many` relationship with the `Patient` model through the `Appointment` model.

### Slot

This model represents a 30 minute time slot. It has a `time ` attribute that is used to store the time of the slot. It has a `belongs_to` relationship with the `Doctor` model and a `has_one` relationship with the `Appointment` model.

A validation is provided to ensure that a doctor can't have two slots at the same time.

A given slot is considered available if it doesn't have an appointment associated with it, and if it's in the future.

### Appointment

This model represents an appointment done by a patient. It has a `belongs_to` relationship with the `Slot` model and a `belongs_to` relationship with the `Patient` model.

A unique validation on slot_id is provided to ensure that a slot can't have two appointments associated with it.

### Patient

This model has a `has_many` relationship with the `Appointment` model and a `has_many` relationship with the `Doctor` model through the `Appointment` model.

## API

### GET /doctors

Returns a list of doctors.

```
[
  {
    "id": 1,
    "name": "Tomeka Dicki"
  },
  {
    "id": 2,
    "name": "Tyron Greenfelder"
  }
]
```

### GET /doctors/:id

Returns all the available slots for a doctor from today onwards.

Example response for `/doctors/1`

```
{
  "id": 1,
  "name": "Tomeka Dicki",
  "available_slots": [
    {
      "id": 3,
      "time": "2023-09-09T18:04:51.000Z"
    },
    {
      "id": 4,
      "time": "2023-09-09T18:34:51.000Z"
    },
    {
      "id": 5,
      "time": "2023-09-09T19:04:51.000Z"
    },
    {
      "id": 6,
      "time": "2023-09-09T19:34:51.000Z"
    }
  ]
}
```

### GET /doctors/:id/working_hours

Returns a list of the doctor's slots for a given date.

Example response for `/doctors/1/working_hours?date=2023-09-09`

```
{
  "id": 1,
  "name": "Tomeka Dicki",
  "working_hours": [
    {
      "id": 1,
      "time": "2023-09-09T17:04:51.000Z"
    },
    {
      "id": 2,
      "time": "2023-09-09T17:34:51.000Z"
    },
    {
      "id": 3,
      "time": "2023-09-09T18:04:51.000Z"
    },
    {
      "id": 4,
      "time": "2023-09-09T18:34:51.000Z"
    }
  ]
}
```

### POST /appointments

Books an appointment for a given time slot. The patient is assumed to be the one with the token passed in the `Authorization` header.

Example request:

```
{
  "appointment": {
    "time_slot_id": 3
  }
}
```

Example response:

```
{
  "id": 1,
  "time": "2023-09-09T18:04:51.000Z",
  "doctor": {
    "id": 1,
    "name": "Tomeka Dicki"
  }
}
```

In case of error, returns a 422 status code with the following body:

```
{
  "errors": [
    "Slot has already been taken"
  ]
}
```

### PATCH /appointments/:id

Modifies an appointment's slot_id. The patient is assumed to be the one with the token passed in the `Authorization` header.
The new slot must be available, otherwise a 422 status code is returned.

Example request: `/appointments/1`

```
{
  "appointment": {
    "time_slot_id": 4
  }
}
```

Example response:

```
{
  "id": 1,
  "time": "2023-09-09T18:34:51.000Z",
  "doctor": {
    "id": 1,
    "name": "Tomeka Dicki"
  }
}
```

### GET /appointments

Returns a list of appointments for the patient with the token passed in the `Authorization` header.

Example response:

```
[
  {
    "id": 1,
    "time": "2023-09-09T18:34:51.000Z",
    "doctor": {
      "id": 1,
      "name": "Tomeka Dicki"
    }
  }
]
```

### DELETE /appointments/:id

Deletes an appointment. The patient is assumed to be the one with the token passed in the `Authorization` header.
