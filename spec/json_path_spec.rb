require "spec_helper"
require "json_path"
require "json"

def prepare
  json = <<-HEREDOC
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
    HEREDOC
 JSON.parse(json)
end

RSpec.describe JsonPath do
  context "#on" do
    it "$.store.book[*].author can get the authors of all books in the store" do
      json = prepare
      path = "$.store.book[*].author"
      output = ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]
      JsonPath.new(path).on(json).should eq(output)
    end

    it "$..author can get all authors" do
      path = "$..author"
      output = ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$.store.* can get all things in store, which are some books and a red bicycle" do
      path = "$.store.*"
      output = JSON.parse <<-HERE
        [
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
      HERE
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$.store..price can get the price of everything in the store" do
      path="$.store..price"
      output= [ 8.95, 12.99, 8.99, 22.99, 19.95 ]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[2] can get the third book" do
      path="$..book[2]"
      output= [
         {
            "category" => "fiction",
            "author"   => "Herman Melville",
            "title"    => "Moby Dick",
            "isbn"     => "0-553-21311-3",
            "price"    =>  8.99
         }
      ]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[(@.length-1)] can get the last element" do
      path="$..book[(@.length-1)]"
      output = [{
        "category" => "fiction",
        "author" => "J. R. R. Tolkien",
        "title" => "The Lord of the Rings",
        "isbn" => "0-395-19395-8",
        "price" => 22.99
      }]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[-1:] can get the last book in order." do
      path="$..book[-1:]"
      output = [{
        "category" => "fiction",
        "author" => "J. R. R. Tolkien",
        "title" => "The Lord of the Rings",
        "isbn" => "0-395-19395-8",
        "price" => 22.99
      }]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[0,1] can get the first two books" do
      path="$..book[0,1]"
      output = [{
        "category" => "reference",
        "author" => "Nigel Rees",
        "title" => "Sayings of the Century",
        "price" => 8.95
      },
      {
        "category" => "fiction",
        "author" => "Evelyn Waugh",
        "title" => "Sword of Honour",
        "price" => 12.99
      }]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[:2] can get the first two books" do
      path="$..book[:2]"
      output = [{
        "category" => "reference",
        "author" => "Nigel Rees",
        "title" => "Sayings of the Century",
        "price" => 8.95
      },
      {
        "category" => "fiction",
        "author" => "Evelyn Waugh",
        "title" => "Sword of Honour",
        "price" => 12.99
      }]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[?(@.isbn)] can filter all books with isbn number" do
      path="$..book[?(@.isbn)]"
      output = [{
            "category" => "fiction",
            "author" => "Herman Melville",
            "title" => "Moby Dick",
            "isbn" => "0-553-21311-3",
            "price" => 8.99
         },
         {
            "category" => "fiction",
            "author" => "J. R. R. Tolkien",
            "title" => "The Lord of the Rings",
            "isbn" => "0-395-19395-8",
            "price" => 22.99
         }]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..book[?(@.price<10)] can filter all books cheapier than 10" do
      path="$..book[?(@.price<10)]"
      output = [
        {
          "category" => "reference",
          "author" => "Nigel Rees",
          "title" => "Sayings of the Century",
          "price" => 8.95
        },
        {
          "category" => "fiction",
          "author" => "Herman Melville",
          "title" => "Moby Dick",
          "isbn" => "0-553-21311-3",
          "price" => 8.99
        }
      ]
      JsonPath.new(path).on(prepare).should eq(output)
    end

    it "$..* can get All members of JSON structure" do
      path="$..*"
      output=[
        {
          "book" => [
            {
              "category" => "reference",
              "author" => "Nigel Rees",
              "title" => "Sayings of the Century",
              "price" => 8.95
            },
            {
              "category" => "fiction",
              "author" => "Evelyn Waugh",
              "title" => "Sword of Honour",
              "price" => 12.99
            },
            {
              "category" => "fiction",
              "author" => "Herman Melville",
              "title" => "Moby Dick",
              "isbn" => "0-553-21311-3",
              "price" => 8.99
            },
            {
              "category" => "fiction",
              "author" => "J. R. R. Tolkien",
              "title" => "The Lord of the Rings",
              "isbn" => "0-395-19395-8",
              "price" => 22.99
            }
          ],
          "bicycle" => {
            "color" => "red",
            "price" => 19.95
          }
        },
        10,
        [
          {
            "category" => "reference",
            "author" => "Nigel Rees",
            "title" => "Sayings of the Century",
            "price" => 8.95
          },
          {
            "category" => "fiction",
            "author" => "Evelyn Waugh",
            "title" => "Sword of Honour",
            "price" => 12.99
          },
          {
            "category" => "fiction",
            "author" => "Herman Melville",
            "title" => "Moby Dick",
            "isbn" => "0-553-21311-3",
            "price" => 8.99
          },
          {
            "category" => "fiction",
            "author" => "J. R. R. Tolkien",
            "title" => "The Lord of the Rings",
            "isbn" => "0-395-19395-8",
            "price" => 22.99
          }
        ],
        {
          "color" => "red",
          "price" => 19.95
        },
        {
          "category" => "reference",
          "author" => "Nigel Rees",
          "title" => "Sayings of the Century",
          "price" => 8.95
        },
        {
          "category" => "fiction",
          "author" => "Evelyn Waugh",
          "title" => "Sword of Honour",
          "price" => 12.99
        },
        {
          "category" => "fiction",
          "author" => "Herman Melville",
          "title" => "Moby Dick",
          "isbn" => "0-553-21311-3",
          "price" => 8.99
        },
        {
          "category" => "fiction",
          "author" => "J. R. R. Tolkien",
          "title" => "The Lord of the Rings",
          "isbn" => "0-395-19395-8",
          "price" => 22.99
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
      JsonPath.new(path).on(prepare).should eq(output)
    end
  end
end