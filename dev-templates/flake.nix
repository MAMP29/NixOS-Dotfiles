{
  description = "Plantillas de desarrollo para Nix";

  outputs = { self }: {
    templates = {
      # Python - pyproject
      python-pyproject = {
        path = ./templates/python-pyproject;
        description = "Entorno de Python con pyproject y direnv";
      };

      #  Java - Gradle
      java-gradle = {
        path = ./templates/java-gradle;
        description = "Entorno de Java (Zulu 21) con Gradle y direnv";
      };
      
      #  Java - Maven
      java-maven = {
        path = ./templates/java-maven;
        description = "Entorno de Java (Zulu 21) con Maven y direnv";
      };

      # NodeJs
      nodejs = {
        path = ./templates/nodejs;
        description = "Entorno para NodeJs 24 y direnv";
      };
    };
  };
}