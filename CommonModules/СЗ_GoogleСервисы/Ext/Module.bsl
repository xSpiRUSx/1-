
Функция СоздатьКалендарь() Экспорт
	
	//POST https://www.googleapis.com/calendar/v3/users/me/calendarList
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Календари.Наименование КАК Наименование,
	|	Календари.Ссылка КАК Ссылка,
	|	Календари.ID КАК ID
	|ИЗ
	|	Справочник.Календари КАК Календари
	|ГДЕ
	|	Календари.ID = &ID";
	
	Запрос.УстановитьПараметр("ID", "");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
		ДанныеДляЗапроса = Новый Структура;
		ДанныеДляЗапроса.Вставить("id", "1С");
		ДанныеДляЗапроса.Вставить("summary", ВыборкаДетальныеЗаписи.Наименование);
		
		
		ЗаписьJOIN = Новый ЗаписьJSON;
		ЗаписьJOIN.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJOIN, ДанныеДляЗапроса);
		СтрокаДляЗапроса = ЗаписьJOIN.Закрыть();
		
		
		
		РезультатЗапроса = СЗ_HTTPЗапросы.POST_ВыполнитьЗапрос("www.googleapis.com", "/calendar/v3/users/me/calendarList",,,СтрокаДляЗапроса);
		
		Если НЕ РезультатЗапроса.Результат Тогда
			
		КонецЕсли;
		
		СтруктураКалендарей = РазобратьJson_ПолучитьКалендари(РезультатЗапроса.ТекстОтвета);
		
		
		
		
		
	КонецЦикла;
	
			
			


	
КонецФункции

Функция ПолучитьКалендари() Экспорт
	
	Заголовки = Новый Структура;
	Заголовки.Вставить("showHidden", Истина); //Показывать скрытые календари

	РезультатЗапроса = СЗ_HTTPЗапросы.GET_ВыполнитьЗапрос("www.googleapis.com", "/calendar/v3/users/me/calendarList",,Заголовки);
	
	Если НЕ РезультатЗапроса.Результат Тогда
			
	КонецЕсли;
	
	СтруктураКалендарей = РазобратьJson_ПолучитьКалендари(РезультатЗапроса.ТекстОтвета);

	
	Для Каждого Календарь Из СтруктураКалендарей Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Календари.Наименование КАК Наименование,
		|	Календари.Ссылка КАК Ссылка,
		|	Календари.ID КАК ID
		|ИЗ
		|	Справочник.Календари КАК Календари
		|ГДЕ
		|	Календари.ID = &ID";
		
		Запрос.УстановитьПараметр("ID", Календарь.id);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			
			КалендарьОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			КалендарьОбъект.Наименование = ?(Календарь.Свойство("description"), Календарь.description, Календарь.id);
			КалендарьОбъект.Записать();
			
		Иначе	
			
			КалендарьОбъект = Справочники.Календари.СоздатьЭлемент();
			КалендарьОбъект.Наименование = ?(Календарь.Свойство("description"), Календарь.description, Календарь.id);
			КалендарьОбъект.ID = Календарь.id;
			КалендарьОбъект.Записать();
			
		КонецЕсли;

	КонецЦикла;
	
КонецФункции

Функция ПолучитьМероприятия() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Календари.ID КАК ID
		|ИЗ
		|	Справочник.Календари КАК Календари
		|ГДЕ
		|	Календари.Выбран";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
		РезультатЗапроса = СЗ_HTTPЗапросы.GET_ВыполнитьЗапрос("www.googleapis.com", "/calendar/v3/calendars/" + ВыборкаДетальныеЗаписи.ID + "/events"); 
		
		Если НЕ РезультатЗапроса.Результат Тогда
			
	КонецЕсли;
	
	СтруктураМероприятий = РазобратьJson_ПолучитьКалендари(РезультатЗапроса.ТекстОтвета);
	
	Для Каждого Мероприятие Из СтруктураМероприятий Цикл
		
		Запись = РегистрыСведений.МероприятияКалендаря.СоздатьМенеджерЗаписи();		
		ЗаполнитьЗначенияСвойств(Запись, Мероприятие);
		
		Запись.created = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.created);
		Запись.updated = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.updated);
		Если Мероприятие.start.Свойство("dateTime") Тогда
			Запись._start = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.start.dateTime);
		КонецЕсли;
		Если Мероприятие.start.Свойство("date") Тогда
			Запись._start = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.start.date);
		КонецЕсли;
		Если Мероприятие.end.Свойство("dateTime") Тогда
			Запись._end = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.end.dateTime);
		КонецЕсли;
		Если Мероприятие.end.Свойство("date") Тогда
			Запись._end = СЗ_HTTPЗапросы.ДатаИзФорматаGoogle(Мероприятие.end.date);
		КонецЕсли;
		
		
		Запись.Записать(Истина);
		
	КонецЦикла;
		
КонецЦикла;

	
КонецФункции
	
Функция СоздатьМероприятие() Экспорт
	
	
	
	                                     
	
КонецФункции


Функция РазобратьJson_ПолучитьКалендари(ТекстОтвета)
	
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку(ТекстОтвета); 
	ЗаписьJSON = ПрочитатьJSON(ЧтениеJSON); 
	ЧтениеJSON.Закрыть();
	
	Списки = ЗаписьJSON.items;

	Возврат Списки;                                                    
	
КонецФункции
