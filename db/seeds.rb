# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Book.create!(author: 'Agatha Christie', title: 'Frequent Hearses',
             genre: 'Crime/Detective', isbn: '966677850-5', copies: 10)

Book.create!(author: 'Ricarda Kuhic IV', title: 'Those Barren Leaves, Thrones, Dominations',
             genre: 'Reference book', isbn: '725199056-3', copies: 10)

User.create!(email: 'leoma_waelchi@reynolds.test', password: '1Owsn9BUDSuzr4g')
User.create!(email: 'blair.marks@russel-howell.example', password: 'N4raOMHAjL7HG', role: 'librarian')
