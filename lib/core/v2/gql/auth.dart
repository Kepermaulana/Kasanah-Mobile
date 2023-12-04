// String login = """
//  mutation(\$input:LoginInput){
//   login(input:\$input){
//   token
//     user{
//       id
//       firstName
//       role
//     }
// }}
// """;

String register = """
mutation(\$input: RegisterInput){
  register(input:\$input){
    token
    user{
      id
      firstName
      role
    }
  }
}
""";
