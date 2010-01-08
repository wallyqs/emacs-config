// No se puede usar Object.prototype porque arruina
// los objetos normales de javascript
//
// Ejemplo:
// var novia = {
//   nombre: "Mariko!!!",
//   apellido: "Minami!!!",
//   say: function (){
//     return this.nombre + " " + this.apellido;
//   }
// };

// VALUES TE DIRIA QUE PROPIEDADES TIENE UN OBJETO
function values(object) {
  var results = [];
  for (var property in object){
    var cell =  property + ": ";
    if (typeof object[property] === "function"){
      // cell += "function";
      // results.push(cell);
    }
    else {
      cell += object[property];
      results.push(cell);
    }
  }
  return results;
}

// METHODS TE DICE QUE FUNCIONES TIENE
function methods(object) {
  var results = [];
  for (var property in object){
    var cell = "";
    if (typeof object[property] === "function"){
      cell += property;
      results.push(cell);
    }
  }
  return results;
}