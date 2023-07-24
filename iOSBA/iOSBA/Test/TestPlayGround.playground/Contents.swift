import UIKit

struct Student {
    let name: String
    let testScore: Int
}

let students = [
    Student(name: "Oswaldo Ferral", testScore: 50),
    Student(name: "Juan Olmos", testScore: 80),
    Student(name: "Roberto Carlos", testScore: 70),
    Student(name: "Eduardo Hernandez", testScore: 90),
    Student(name: "Enrique Saenz", testScore: 30),
]

/// El primer paréntesis son los datos que nos pueden llegar, el segundo es el que retorna y el "student in " es como usas o como le llamas al valor que recibiste
/// Es muy muy similar  a las arrow functions que usabas
var topStudentsFilter: (Student) -> Bool = { student in
    return student.testScore > 80
}

/// Si nos damos cuenta es muy similar uno con otro, son casi idénticos solo que se usa el in para el nombre de las variables y aca tenermos nombre y tipo pegado
func midStudentFilter(student:Student) -> Bool {
    return student.testScore > 60
}


//Lo mas importante y que debes entender es que un closure es una función que puedes usar como variable que la puedes pasar
//Notalo aquí el filter te pide una función que le indique como es que necesitas es filtro de algún array y aquí lejos de hacerlo ahi en el filter solo mandamos llamar nuestro closure
//La función también sirve pero no la puedes pasar como variable
// Ojito, prefieres que sea un closure por el simple hecho de que quieres que el codigo se pueda reutilizar

let topStudents = students.filter(topStudentsFilter)

// los closures tienen una manera de hacer más rapido el nombrado de las variables , solo con $0 para el primer valor, $1 para el segundo y así subsecuentemente
let studentFilter = students.filter {$0.testScore > 50}

// Otra manera de usarlo
var studentsTest: (Student, Int, String) -> Bool = {
    print("El valor del string es \($2)")
    return $0.testScore > $1
}

studentsTest(students[0], 70, "Hola")


// Fijate que en los filter y sortedBy no mandamos valor porque el filter y sorted hace la función como de un sort que le manda el valor


/// Hablando de lo de network , solemos usar closures con @escaping con algo similar a un closure () -> () que devuelve nada o una función , lo que indicamos aquí es que esta función va seguir viva después de que el código digamos haya
/// hecho su ejecución va seguir ahí
