class Recipe {
  final String title;
  final String imageUrl;
  final String difficulty;
  final String time;
  final String description;
  final String calories;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.calories,
    required this.ingredients,
  });
}

final List<Recipe> newRecipes = [
  Recipe(
    title: 'Pizza Margarita Clásica',
    imageUrl:
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '45 min',
    description:
        'Una pizza simple pero deliciosa con albahaca fresca, mozzarella y salsa de tomate.',
    calories: '800 kcal',
    ingredients: [
      '1 base de Masa de pizza',
      '200ml Salsa de tomate',
      '200g Mozzarella fresca',
      '10 hojas Albahaca fresca',
      '2 cdas Aceite de oliva',
    ],
  ),
  Recipe(
    title: 'Tostada de Aguacate',
    imageUrl: 'assets/images/avocado_toast.png',
    difficulty: 'Fácil',
    time: '10 min',
    description:
        'Aguacate cremoso sobre pan de masa madre tostado con una pizca de hojuelas de chile.',
    calories: '350 kcal',
    ingredients: [
      '2 rebanadas Pan de masa madre',
      '1 Aguacate maduro',
      'Al gusto Sal y pimienta',
      '1 pizca Hojuelas de chile',
      '1/2 Jugo de limón',
    ],
  ),
  Recipe(
    title: 'Salmón a la Parrilla',
    imageUrl:
        'https://images.unsplash.com/photo-1485921325833-c519f76c4927?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '25 min',
    description:
        'Filete de salmón fresco asado a la perfección con limón y hierbas.',
    calories: '450 kcal',
    ingredients: [
      '200g Filete de salmón',
      '1/2 Limón',
      '1 rama Eneldo fresco',
      '1 diente Ajo',
      '1 cda Aceite de oliva',
    ],
  ),
  Recipe(
    title: 'Bowl de Batido de Frutos Rojos',
    imageUrl: 'assets/images/berry_smoothie_bowl.png',
    difficulty: 'Fácil',
    time: '15 min',
    description:
        'Un refrescante bowl de batido cubierto con frutos rojos frescos, granola y miel.',
    calories: '300 kcal',
    ingredients: [
      '1 taza Fresas congeladas',
      '1 Plátano',
      '200ml Leche de almendras',
      '50g Granola',
      '1 cda Miel',
    ],
  ),
  Recipe(
    title: 'Risotto de Champiñones',
    imageUrl:
        'https://images.unsplash.com/photo-1476124369491-e7addf5db371?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Difícil',
    time: '50 min',
    description:
        'Plato de arroz italiano cremoso cocinado con champiñones silvestres y queso parmesano.',
    calories: '600 kcal',
    ingredients: [
      '300g Arroz Arborio',
      '200g Champiñones variados',
      '1L Caldo de verduras',
      '100ml Vino blanco',
      '50g Queso Parmesano',
    ],
  ),
  Recipe(
    title: 'Ensalada César',
    imageUrl:
        'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '20 min',
    description:
        'Lechuga romana crujiente con picatostes, parmesano y aderezo César clásico.',
    calories: '400 kcal',
    ingredients: [
      '1 Lechuga romana',
      '50g Pan tostado (picatostes)',
      '30g Queso Parmesano',
      '3 cdas Aderezo César',
      '1 Pechuga de pollo (opcional)',
    ],
  ),
  Recipe(
    title: 'Tacos al Pastor',
    imageUrl:
        'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '60 min',
    description:
        'Clásicos tacos mexicanos con carne de cerdo marinada, piña y cilantro.',
    calories: '550 kcal',
    ingredients: [
      '500g Carne de cerdo',
      '100g Piña',
      '10 Tortillas de maíz',
      'Cilantro y cebolla picados',
      'Salsa al gusto',
    ],
  ),
  Recipe(
    title: 'Pad Thai',
    imageUrl:
        'https://images.unsplash.com/photo-1559314809-0d155014e29e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '40 min',
    description:
        'Fideos de arroz salteados con camarones, tofu, cacahuetes y salsa de tamarindo.',
    calories: '600 kcal',
    ingredients: [
      '200g Fideos de arroz',
      '150g Camarones',
      '100g Tofu firme',
      '50g Cacahuetes tostados',
      'Salsa Pad Thai',
    ],
  ),
  Recipe(
    title: 'Hamburguesa Gourmet',
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '30 min',
    description:
        'Jugosa carne de res con queso cheddar, cebolla caramelizada y pan brioche.',
    calories: '850 kcal',
    ingredients: [
      '200g Carne de res molida',
      '1 Pan Brioche',
      '1 rebanada Queso Cheddar',
      'Cebolla caramelizada',
      'Lechuga y tomate',
    ],
  ),
  Recipe(
    title: 'Sushi Roll California',
    imageUrl:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Difícil',
    time: '50 min',
    description:
        'Rollos de sushi con surimi, aguacate y pepino, envueltos en arroz y sésamo.',
    calories: '350 kcal',
    ingredients: [
      '200g Arroz para sushi',
      '3 hojas Alga Nori',
      '100g Surimi',
      '1 Aguacate',
      '1 Pepino',
    ],
  ),
  Recipe(
    title: 'Paella Valenciana',
    imageUrl:
        'https://images.unsplash.com/photo-1515443961218-a51367888e4b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Difícil',
    time: '90 min',
    description:
        'Arroz tradicional español con pollo, conejo, judías verdes y azafrán.',
    calories: '700 kcal',
    ingredients: [
      '400g Arroz bomba',
      '300g Pollo troceado',
      '200g Judías verdes planas',
      'Caldo de pollo',
      'Azafrán',
    ],
  ),
  Recipe(
    title: 'Curry Verde Tailandés',
    imageUrl: 'assets/images/thai_green_curry.png',
    difficulty: 'Medio',
    time: '45 min',
    description:
        'Pollo en salsa de curry verde con leche de coco, bambú y albahaca tailandesa.',
    calories: '550 kcal',
    ingredients: [
      '400ml Leche de coco',
      '2 cdas Pasta de curry verde',
      '300g Pechuga de pollo',
      'Brotes de bambú',
      'Albahaca tailandesa',
    ],
  ),
  Recipe(
    title: 'Lasaña de Carne',
    imageUrl: 'assets/images/meat_lasagna.png',
    difficulty: 'Medio',
    time: '80 min',
    description:
        'Capas de pasta, salsa boloñesa, bechamel y queso gratinado al horno.',
    calories: '750 kcal',
    ingredients: [
      'Láminas de lasaña',
      '500g Carne picada',
      'Salsa de tomate',
      'Salsa bechamel',
      'Queso rallado',
    ],
  ),
  Recipe(
    title: 'Falafel con Hummus',
    imageUrl: 'assets/images/falafel_hummus.png',
    difficulty: 'Medio',
    time: '40 min',
    description:
        'Croquetas de garbanzos especiadas servidas con crema de garbanzos y pan pita.',
    calories: '450 kcal',
    ingredients: [
      '200g Garbanzos secos',
      'Cebolla y ajo',
      'Comino y cilantro',
      'Pan pita',
      'Hummus para acompañar',
    ],
  ),
  Recipe(
    title: 'Ceviche Peruano',
    imageUrl:
        'https://images.unsplash.com/photo-1535399831218-d5bd36d1a6b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '20 min',
    description:
        'Pescado fresco marinado en jugo de limón con cebolla morada, ají y cilantro.',
    calories: '300 kcal',
    ingredients: [
      '500g Pescado blanco fresco',
      '1 taza Jugo de limón',
      '1 Cebolla morada',
      'Ají limo',
      'Cilantro fresco',
    ],
  ),
  Recipe(
    title: 'Pollo Tikka Masala',
    imageUrl:
        'https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '60 min',
    description:
        'Pollo marinado en yogur y especias, cocinado en una salsa cremosa de tomate.',
    calories: '600 kcal',
    ingredients: [
      '500g Pollo troceado',
      'Yogur natural',
      'Garam Masala',
      'Salsa de tomate',
      'Crema de leche',
    ],
  ),
  Recipe(
    title: 'Ratatouille',
    imageUrl:
        'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '50 min',
    description:
        'Guiso tradicional francés de verduras asadas: berenjena, calabacín y pimientos.',
    calories: '250 kcal',
    ingredients: [
      '1 Berenjena',
      '1 Calabacín',
      '1 Pimiento rojo',
      'Tomates maduros',
      'Hierbas provenzales',
    ],
  ),
  Recipe(
    title: 'Brownie de Chocolate',
    imageUrl:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '40 min',
    description:
        'Bizcocho denso y húmedo de chocolate con nueces, perfecto para el postre.',
    calories: '400 kcal',
    ingredients: [
      '200g Chocolate negro',
      '150g Mantequilla',
      '150g Azúcar',
      '3 Huevos',
      '100g Nueces',
    ],
  ),
  Recipe(
    title: 'Gazpacho Andaluz',
    imageUrl: 'assets/images/gazpacho_andaluz.png',
    difficulty: 'Fácil',
    time: '15 min',
    description:
        'Sopa fría de tomate, pimiento y pepino, ideal para los días calurosos.',
    calories: '150 kcal',
    ingredients: [
      '1kg Tomates maduros',
      '1 Pimiento verde',
      '1 Pepino',
      'Aceite de oliva',
      'Vinagre de Jerez',
    ],
  ),
  Recipe(
    title: 'Ramen de Cerdo',
    imageUrl: 'assets/images/pork_ramen.png',
    difficulty: 'Difícil',
    time: '120 min',
    description:
        'Sopa de fideos japonesa con caldo de cerdo, huevo marinado y nori.',
    calories: '650 kcal',
    ingredients: [
      'Fideos Ramen',
      'Caldo de cerdo (Tonkotsu)',
      'Chashu (cerdo braseado)',
      'Huevo marinado',
      'Cebollino',
    ],
  ),
  Recipe(
    title: 'Tarta de Queso',
    imageUrl:
        'https://images.unsplash.com/photo-1524351199678-941a58a3df50?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Medio',
    time: '70 min',
    description:
        'Tarta cremosa de queso estilo New York con base de galleta y cobertura de frutos rojos.',
    calories: '500 kcal',
    ingredients: [
      '600g Queso crema',
      '200g Galletas tipo María',
      '150g Azúcar',
      '3 Huevos',
      'Mermelada de fresa',
    ],
  ),
  Recipe(
    title: 'Arepas Rellenas',
    imageUrl: 'assets/images/arepas_rellenas.png',
    difficulty: 'Medio',
    time: '45 min',
    description:
        'Panecillos de maíz venezolanos rellenos de carne mechada y queso amarillo.',
    calories: '480 kcal',
    ingredients: [
      'Harina de maíz precocida',
      'Agua y sal',
      'Carne mechada',
      'Queso rallado',
      'Mantequilla',
    ],
  ),
  Recipe(
    title: 'Macarons Franceses',
    imageUrl:
        'https://images.unsplash.com/photo-1569864358642-9d1684040f43?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Difícil',
    time: '90 min',
    description:
        'Delicados dulces de almendra con relleno de ganache de chocolate o crema de frutas.',
    calories: '100 kcal',
    ingredients: [
      'Harina de almendra',
      'Azúcar glass',
      'Claras de huevo',
      'Colorante alimentario',
      'Relleno al gusto',
    ],
  ),
  Recipe(
    title: 'Poke Bowl de Atún',
    imageUrl:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    difficulty: 'Fácil',
    time: '20 min',
    description:
        'Bowl hawaiano con atún fresco marinado, arroz, aguacate y edamame.',
    calories: '450 kcal',
    ingredients: [
      '200g Atún fresco en cubos',
      'Arroz de sushi',
      'Aguacate',
      'Edamame',
      'Salsa de soja y sésamo',
    ],
  ),
];
