global class CONS_EstructuraproductoBanco_JSON {

        public string rut_cliente;
        public string estado;
        public string id_producto;
        public string nombre_producto;
        public string id_operacion;
        
        
    public static CONS_EstructuraproductoBanco_JSON parse(String json) {
        system.debug('json'+json);
        return (CONS_EstructuraproductoBanco_JSON) System.JSON.deserialize(json, CONS_EstructuraproductoBanco_JSON.class);

    
}
}