# JsonPath
Ruby conversion of the Javascript JSONPath from http://goessner.net/articles/JsonPath/


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_path'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_path

## Usage

```json
 { "store": {
        "book": [
          { "category": "reference",
            "author": "Nigel Rees",
            "title": "Sayings of the Century",
            "price": 8.95
          },
          { "category": "fiction",
            "author": "Evelyn Waugh",
            "title": "Sword of Honour",
            "price": 12.99
          },
          { "category": "fiction",
            "author": "Herman Melville",
            "title": "Moby Dick",
            "isbn": "0-553-21311-3",
            "price": 8.99
          },
          { "category": "fiction",
            "author": "J. R. R. Tolkien",
            "title": "The Lord of the Rings",
            "isbn": "0-395-19395-8",
            "price": 22.99
          }
        ],
        "bicycle": {
          "color": "red",
          "price": 19.95
        }
      } ,
      "expensive": 10
    }
```

`$.store.book[*].author` can get the authors of all books in the store

```json 
["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"] 
```

`$..author` can get all authors

```json 
["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]
```

`$.store.*` can get all things in store, which are some books and a red bicycle

```json 
[
      {
         "category" : "reference",
         "author" : "Nigel Rees",
         "title" : "Sayings of the Century",
         "price" : 8.95
      },
      {
         "category" : "fiction",
         "author" : "Evelyn Waugh",
         "title" : "Sword of Honour",
         "price" : 12.99
      },
      {
         "category" : "fiction",
         "author" : "Herman Melville",
         "title" : "Moby Dick",
         "isbn" : "0-553-21311-3",
         "price" : 8.99
      },
      {
         "category" : "fiction",
         "author" : "J. R. R. Tolkien",
         "title" : "The Lord of the Rings",
         "isbn" : "0-395-19395-8",
         "price" : 22.99
      }
   ],
   {
      "color" : "red",
      "price" : 19.95
   }
]
```

`$.store..price` can get the price of everything in the store

```json 
[ 8.95, 12.99, 8.99, 22.99, 19.95 ]
````
    
`$..book[2]` can get the third book

```json  
[ 
  {
      "category" : "fiction",
      "author"   : "Herman Melville",
      "title"    : "Moby Dick",
      "isbn"     : "0-553-21311-3",
      "price"    :  8.99
   }
]
```

`$..book[(@.length-1)]` can get the last element

```json 
[{
  "category" : "fiction",
  "author" : "J. R. R. Tolkien",
  "title" : "The Lord of the Rings",
  "isbn" : "0-395-19395-8",
  "price" : 22.99
}]
```

`$..book[-1:]` can get the last book in order

```json 
[{
  "category" : "fiction",
  "author" : "J. R. R. Tolkien",
  "title" : "The Lord of the Rings",
  "isbn" : "0-395-19395-8",
  "price" : 22.99
}]
```

`$..book[0,1]` can get the first two books

```json
[{
  "category" : "reference",
  "author" : "Nigel Rees",
  "title" : "Sayings of the Century",
  "price" : 8.95
},
{
  "category" : "fiction",
  "author" : "Evelyn Waugh",
  "title" : "Sword of Honour",
  "price" : 12.99
}]
```

`$..book[:2]` can get the first two books

```json 
[{
    "category" : "reference",
    "author" : "Nigel Rees",
    "title" : "Sayings of the Century",
    "price" : 8.95
  },
  {
    "category" : "fiction",
    "author" : "Evelyn Waugh",
    "title" : "Sword of Honour",
    "price" : 12.99
  }]
```
    
`$..book[?(@.isbn)]` can filter all books with isbn number

```json 
[{
        "category" : "fiction",
        "author" : "Herman Melville",
        "title" : "Moby Dick",
        "isbn" : "0-553-21311-3",
        "price" : 8.99
     },
     {
        "category" : "fiction",
        "author" : "J. R. R. Tolkien",
        "title" : "The Lord of the Rings",
        "isbn" : "0-395-19395-8",
        "price" : 22.99
     }]
 ```

`$..book[?(@.price<10)]` can filter all books cheapier than 10

```json
[
  {
    "category" : "reference",
    "author" : "Nigel Rees",
    "title" : "Sayings of the Century",
    "price" : 8.95
  },
  {
    "category" : "fiction",
    "author" : "Herman Melville",
    "title" : "Moby Dick",
    "isbn" : "0-553-21311-3",
    "price" : 8.99
  }
]
```

`$..*` can get All members of JSON structure

```json
[
{
  "book" : [
    {
      "category" : "reference",
      "author" : "Nigel Rees",
      "title" : "Sayings of the Century",
      "price" : 8.95
    },
    {
      "category" : "fiction",
      "author" : "Evelyn Waugh",
      "title" : "Sword of Honour",
      "price" : 12.99
    },
    {
      "category" : "fiction",
      "author" : "Herman Melville",
      "title" : "Moby Dick",
      "isbn" : "0-553-21311-3",
      "price" : 8.99
    },
    {
      "category" : "fiction",
      "author" : "J. R. R. Tolkien",
      "title" : "The Lord of the Rings",
      "isbn" : "0-395-19395-8",
      "price" : 22.99
    }
  ],
  "bicycle" : {
    "color" : "red",
    "price" : 19.95
  }
},
10,
[
  {
    "category" : "reference",
    "author" : "Nigel Rees",
    "title" : "Sayings of the Century",
    "price" : 8.95
  },
  {
    "category" : "fiction",
    "author" : "Evelyn Waugh",
    "title" : "Sword of Honour",
    "price" : 12.99
  },
  {
    "category" : "fiction",
    "author" : "Herman Melville",
    "title" : "Moby Dick",
    "isbn" : "0-553-21311-3",
    "price" : 8.99
  },
  {
    "category" : "fiction",
    "author" : "J. R. R. Tolkien",
    "title" : "The Lord of the Rings",
    "isbn" : "0-395-19395-8",
    "price" : 22.99
  }
],
{
  "color" : "red",
  "price" : 19.95
},
{
  "category" : "reference",
  "author" : "Nigel Rees",
  "title" : "Sayings of the Century",
  "price" : 8.95
},
{
  "category" : "fiction",
  "author" : "Evelyn Waugh",
  "title" : "Sword of Honour",
  "price" : 12.99
},
{
  "category" : "fiction",
  "author" : "Herman Melville",
  "title" : "Moby Dick",
  "isbn" : "0-553-21311-3",
  "price" : 8.99
},
{
  "category" : "fiction",
  "author" : "J. R. R. Tolkien",
  "title" : "The Lord of the Rings",
  "isbn" : "0-395-19395-8",
  "price" : 22.99
},
"reference",
"Nigel Rees",
"Sayings of the Century",
8.95,
"fiction",
"Evelyn Waugh",
"Sword of Honour",
12.99,
"fiction",
"Herman Melville",
"Moby Dick",
"0-553-21311-3",
8.99,
"fiction",
"J. R. R. Tolkien",
"The Lord of the Rings",
"0-395-19395-8",
22.99,
"red",
19.95
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lribeiro/json_path. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JsonPath project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lribeiro/json_path/blob/master/CODE_OF_CONDUCT.md).
