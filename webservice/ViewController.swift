//
//  ViewController.swift
//  webservice
//
//  Created by Martin on 9/8/18.
//  Copyright © 2018 curso_swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Creamos una instancia de nuestra clase manejadora de las peticiones al servidor remoto
    let dataJsonUrlClass = JsonClass()

    //conexiones con la IU del storyboard
    @IBOutlet weak var nombreText: UITextField!//nombre
    @IBOutlet weak var apellidoText: UITextField!//apellido
    @IBOutlet weak var correoText: UITextField!//correo
    @IBOutlet weak var mensajeLabel: UILabel!//mensaje de error, 1 o 2 desde el servidor remoto
    @IBOutlet weak var idText: UITextField!//id del usuario a buscar
    @IBOutlet weak var buscarButton: UIButton!//boton de buscar
    
    @IBOutlet weak var fechaaltaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func buscarAccion(_ sender: UIButton) {
        //borramos el contenidod e todos los text
        nombreText.text = ""
        apellidoText.text = ""
        correoText.text = ""
        
        //extraemos el valor del campo de texto (ID usuario)
        let id_usuario = idText?.text
        let nombre = "otro parametro"

        //si idText.text no tienen ningun valor terminamos la ejecución
        if id_usuario == ""{
            return
        }
        
        //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
        let datos_a_enviar = ["id_usuario": id_usuario!,"nombre":nombre] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"users",datos_enviados:datos_a_enviar){ (array_respuesta) in
            
            DispatchQueue.main.async {//proceso principal
                
                /*
                 recibimos un array de tipo:
                 (
                     [0] => Array
                     (
                         [error] => 1
                         [error_mensaje] => todo correcto
                         [id] => 1
                         [nombre] => Alex
                         [apellido] => Ubago
                         [correo] => alex@hotmail.com
                         [fecha_alta] => 2018-09-08 05:25:26
                     )
                 )
                 object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                 */
                let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                
                /*
                 Nuestra constante “diccionario_datos” quedaria con los siguientes valores:
                 [error] => 1
                 [error_mensaje] => todo correcto
                 [id] => 1
                 [nombre] => Alex
                 [apellido] => Ubago
                 [correo] => alex@hotmail.com
                 [fecha_alta] => 2018-09-08 05:25:26
                 */
                
                //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                if let error = diccionario_datos.object(forKey: "error_mensaje") as! String?{
                    self.mensajeLabel.text = error
                }
                
                if let nombre = diccionario_datos.object(forKey: "nombre") as! String?{
                    self.nombreText.text = nombre
                }
                
                if let apellido = diccionario_datos.object(forKey: "apellido") as! String?{
                    self.apellidoText.text = apellido
                }
                
                if let correo = diccionario_datos.object(forKey: "correo") as! String?{
                    self.correoText.text = correo
                }
                if let fecha_alta = diccionario_datos.object(forKey: "fecha_alta") as! String?{
                    self.fechaaltaLabel.text = fecha_alta
                    //self.correoText.text = correo
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

