//
//  JsonClass.swift
//  webservice
//
//  Created by Martin on 9/8/18.
//  Copyright © 2018 curso_swift. All rights reserved.
//

import UIKit

class JsonClass: NSObject {

    //constantes de nuestra clase
    let urlBase = "http://192.168.1.54:8000/api"//url del servidor remoto
    //let urlBase = "https://facebook.com/api/"
    let key = "123456abcde"//key que autoriza nuestra app para extrauer datos
    let model = UIDevice.current.model//modelo del dispositivo iPhone / iPod / iPad
    let iddevice = UIDevice.current.identifierForVendor!.uuidString//
    let langStr = Locale.current.languageCode!//idioma del dispositivo
    let fecha = "2018-01-01"
    //funcion recibe el array JSON desde el servidor remoto y lo convierte en array tipo NSArray
    /*los parametros de entrada son:
    url -> nombre del archivo .php que va a procesar nuestra solicitud
    datos_enviados -> array de datos que vamos a enviar via POST
    */
    func arrayFromJson(url:String,datos_enviados:NSMutableDictionary, comletionHandler: @escaping (NSArray?) -> Void){
        
            //Concatenamos nuestr url base con el archivo .php que va a procesar la solicitud
        print(url)
            let url = URL(string: "\(urlBase)/\(url)")!//http://localhost:8888/2_1_webservice/webservice1.php
            print(url)
            //convertimos la constante url a tipo URLRequest
            var request = URLRequest(url: url)
        
            //establecemos las cabeceras de la petición JSON estándar
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "GET"//puede ser GET pero por seguridad siempre sera POST
        
            /*
            En las siguientes 4 lineas vamos a concatenar o empujar nuevos valores al array de datos que enviaremos al servidor remoto.
            NOTA. Aquí puedes concatenar otros valores que consideres necesarios para la solicitud por ejemplo
            *latitud, longitud y altitud del usuario
            *fecha local del dispositivo
            *Medidas de los sensores (Acelerómetro. giroscopio, sensor de luz, etc)
            */
            datos_enviados["key"] = key
            datos_enviados["lenguaje"] = langStr
            datos_enviados["model"] = model
            datos_enviados["iddevice"] = iddevice
            datos_enviados["fecha"] = fecha
        
            //Convertimos  el array en formato JSON antes de ser enviada
            request.httpBody = try! JSONSerialization.data(withJSONObject: datos_enviados)
        
            //realizamos la petición al servidor remoto
            print("se realiza peticion al servidor")
        
            let task = URLSession.shared.dataTask(with: request) { datos_recibidos, response, error in
                if error != nil{//detectamos un error y devolvemos el array vacío
                    print("ERROR")

                    comletionHandler(nil)
                }
                else{
                    print("convierte respuesta en array")
                    //tratamos de convertir la respuesta en array
                    do {
                        //imprimimos en consola los datos enviados y los datos recibidos en modo debug
                        print("datos recibidos: \(String(describing: String(data: datos_recibidos!, encoding: .utf8))) - datos enviados: \(datos_enviados)")
                       
                        //Convertimos el JSON recibido del servidor remoto en formato array para ser tratado por el dispositivo
                        if let array = try JSONSerialization.jsonObject(with: datos_recibidos!) as? NSArray {
                            //comletionHandler -> devuelve el array, es equivalente en otros lenguajes a  return(array)
                            comletionHandler(array)
                        }
                    } catch let parseError {
                        //Existe un error en el formato JSON, imprimimos en consola la respuesta para localizar el error
                        print("error servidor PHP \(String(data: datos_recibidos!, encoding: .utf8)) \(parseError)")
                        //detectamos un error y devolvemos el array vacío
                        comletionHandler(nil)
                    }
                }
            }
            task.resume()
      
    }
    
}
