//     ____  ____  ____  ____   __   __ _   __  
//    (  _ \(  __)(  _ \/ ___) /  \ (  ( \ / _\ 
//     ) __/ ) _)  )   /\___ \(  O )/    //    \
//    (__)  (____)(__\_)(____/ \__/ \_)__)\_/\_/
//

class Persona{
  //Configuración de personas
  //Vida máxima en años
  float diametroInicial=2;
  float diametroFinal=20;

  Body body; //Box2D body
  Vec2 pos; //Posición
  float diametro;
  float edad;
  float edadMaxima = 500;

  //Color de la persona, que se calculará al iniciar la persona
  float tonoPersona;
  float saturacionPersona;
  float brilloPersona;

  Persona(){
    diametro = diametroInicial;
    //Añade el body al mundo Box2d
    makeBody(random(width), random(height), diametro * 0.5);
    body.setUserData(this);

    //Nace
    edad = 0;

    //Ponemos uno blanco por cada 10 personas, aproximadamente
    if (random(10)<1) {
      tonoPersona = 0;
      saturacionPersona = 0;
      brilloPersona = 180;
    } else {
      tonoPersona = random(colorLocal.x-3-(contraste*0.2),colorLocal.x+3+contraste*0.2);
      saturacionPersona = random(colorLocal.y-1-(contraste*0.1), colorLocal.y+1+(contraste*0.1));
      //Tomamos el contraste de la nubosidad del momento
      brilloPersona = random(colorLocal.z-3-(contraste*0.2), colorLocal.z+3+contraste*0.2);
    }
  }
   void draw(){
     //Cumple un frame
    edad++;
    //Calculamos el diámetro segun su edad
    diametro=diametroInicial+(edad/edadMaxima)*(diametroFinal-diametroInicial);

    //Obtenemos la posición del objeto box2d
    pos = box2d.getBodyPixelCoord(body);
    Fixture f = body.getFixtureList();
    f.getShape().m_radius= box2d.scalarPixelsToWorld(diametro*0.5);

    //Le aplicacmos una fuerza entre -0.5 y 0.5
    body.applyForce(new Vec2(random(-0.5,0.5), random(-0.5,0.5)), new Vec2(0, 0));

    //Dibujamos el punto
    noFill();
    stroke(tonoPersona, saturacionPersona, brilloPersona);
    strokeWeight(diametro);
    point(pos.x, pos.y);
    
    //Si ha cumplido la edad máxima, muere y nace.
    if (edad>edadMaxima) {
      muereYNace();
    }
    
  }

   
  // En esta función se genera el círculo físico, con su posición y radio.
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.1;
    fd.friction = 0.00;
    fd.restitution = 0.1;

    // Attach fixture to body
    body.createFixture(fd);

    body.setAngularVelocity(random(-10, 10));
  }
  
  //Esta función hacer reiniciar a la persona.
  void muereYNace() {
    diametro = diametroInicial;
    //Nace
    edad = 0;
    //Calcula una posición aleatoria y se la asigna
    body.setTransform(box2d.coordPixelsToWorld(anchoBordeMarco+random(width-anchoBordeMarco*2), anchoBordeMarco+random(height-anchoBordeMarco*2)), 0);
  }
  
  
}
