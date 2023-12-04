String showProducts = """
  query(\$skip:Int!, \$limit:Int!, \$publish:Boolean!){
  productsConnection(
    skip: \$skip,
    limit: \$limit,
    where: {
      publish:\$publish
    }
  ){
    total
    limit
    skip
    data{
      name
      price
      description
      publish
      category{
        id
        image
        name
      }
      images
      stock
      id
      createdBy{
        id
        firstName
        lastName
      }
      createdAt
    }
  }
}
""";

String detailProduct = """
query(\$id: String!){
  product(
      id: \$id
  ){
    id
      name
      price
      description
      category{
        id
        image
        name
      }
      images
      stock
      createdBy{
        id
        firstName
        lastName
      }
  }
}
""";
