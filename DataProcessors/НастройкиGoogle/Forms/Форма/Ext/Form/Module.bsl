
&НаКлиенте
Процедура ПолучитьТокен(Команда)
	ИнтеграцияСГуглСервисамиСЗ.POSTЗапрос_ПолучениеТокена();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьРазрешения(Команда)
	
	Если Не ЗначениеЗаполнено(ClientID) Или Не ЗначениеЗаполнено(ClientSecret) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не заполнены обязательные реквизиты");
		Возврат
	КонецЕсли;
	
	ОткрытьФорму("Обработка.НастройкиGoogle.Форма.ФормаАвторизации");
	
КонецПроцедуры

&НаСервере
Процедура ClientIDПриИзмененииНаСервере()
	РегистрыСведений.НастройкиПодключенияГуглСервисов.ЗаписатьЗначениеНастройки(Перечисления.ВариантыНастроекГуглСервисов.ClientID, ClientID);	
КонецПроцедуры

&НаКлиенте
Процедура ClientIDПриИзменении(Элемент)
	ClientIDПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ClientSecretПриИзмененииНаСервере()
	РегистрыСведений.НастройкиПодключенияГуглСервисов.ЗаписатьЗначениеНастройки(Перечисления.ВариантыНастроекГуглСервисов.ClientSecret, ClientSecret);
КонецПроцедуры

&НаКлиенте
Процедура ClientSecretПриИзменении(Элемент)
	ClientSecretПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокНастроек = РегистрыСведений.НастройкиПодключенияГуглСервисов.ПолучитьСписокНастроек();
	
	ClientID = СписокНастроек.Получить(Перечисления.ВариантыНастроекГуглСервисов.ClientID);
	
	ClientSecret = СписокНастроек.Получить(Перечисления.ВариантыНастроекГуглСервисов.ClientSecret);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТокенНаСервере()
	ИнтеграцияСГуглСервисамиСЗ.POSTЗапрос_ОбновитьТокен();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТокен(Команда)
	ОбновитьТокенНаСервере();
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьЗадачиНаСервере()
	СЗ_GoogleTasks.GET_ОбновитьСписки();
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьЗадачи(Команда)
	СинхронизироватьЗадачиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗадачиНаСервере()
	СЗ_GoogleTasks.GET_ОбновитьЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗадачи(Команда)
	ПолучитьЗадачиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьКалендариНаСервере()
	
	      //  GET https://www.googleapis.com/calendar/v3/users/me/calendarList
	
	Соединение = Новый HTTPСоединение("www.googleapis.com",443,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	Заголовки  = Новый Соответствие;		
	Заголовки.Вставить("Authorization","Bearer " + РегистрыСведений.НастройкиПодключенияГуглСервисов.ПолучитьТокен());
	Заголовки.Вставить("showHidden",Истина);
	
	ЗапросHTTP = Новый HTTPЗапрос("/calendar/v3/users/me/calendarList", Заголовки);
	Ответ = Соединение.ВызватьHTTPМетод("GET", ЗапросHTTP);	
	
	Если НЕ Ответ.КодСостояния = 200 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Ошибка получения параметров авторизации: %1", Ответ.ПолучитьТелоКакСтроку()));	
	КонецЕсли;
	
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
		
	//https://www.googleapis.com/calendar/v3
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКалендари(Команда)
	//ПолучитьКалендариНаСервере();
	СЗ_GoogleСервисы.ПолучитьКалендари();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСобытияКаленаряНаСервере()
	//GET https://www.googleapis.com/calendar/v3/calendars/calendarId/events
	
	Соединение = Новый HTTPСоединение("www.googleapis.com",443,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	ДанныеДляЗапроса = Новый Структура;
	ДанныеДляЗапроса.Вставить("calendarId", "primary");
	
	Заголовки  = Новый Соответствие;	
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовки.Вставить("Authorization","Bearer " + РегистрыСведений.НастройкиПодключенияГуглСервисов.ПолучитьТокен());
	
	СтрокаЗапроса = "";
	
	Для Каждого ПараметрЗапроса Из ДанныеДляЗапроса Цикл
		
		  СтрокаЗапроса = СтрокаЗапроса + ПараметрЗапроса.Ключ + "=" + ПараметрЗапроса.Значение + "&";
		  
	КонецЦикла;
	
	СтрокаЗапроса = Лев(СтрокаЗапроса, СтрДлина(СтрокаЗапроса) - 1);

	
	ЗапросHTTP = Новый HTTPЗапрос("/calendar/v3/calendars/a.d.zagorodnev@gmail.com/events", Заголовки);
//	ЗапросHTTP.УстановитьТелоИзСтроки(СтрокаЗапроса);
	
	Ответ = Соединение.ВызватьHTTPМетод("GET", ЗапросHTTP);	
	
	Если НЕ Ответ.КодСостояния = 200 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Ошибка получения параметров авторизации: %1", Ответ.ПолучитьТелоКакСтроку()));	
	КонецЕсли;
	
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку(ТекстОтвета); 
	ЗаписьJSON = ПрочитатьJSON(ЧтениеJSON); 
	ЧтениеJSON.Закрыть();
	
	
	// Если в списке нет задач то пропустим его
	Если НЕ ЗаписьJSON.Свойство("items") Тогда
		Возврат
	КонецЕсли;

	Мероприятия = ЗаписьJSON.items;
	
	Для Каждого Мероприятие Из Мероприятия Цикл
		
		Запись = РегистрыСведений.МероприятияКалендаря.СоздатьМенеджерЗаписи();		
		ЗаполнитьЗначенияСвойств(Запись, Мероприятие);
		
		Запись.created = ДатаИзФорматаGoogle(Мероприятие.created);
		Запись.updated = ДатаИзФорматаGoogle(Мероприятие.updated);
		Если Мероприятие.start.Свойство("dateTime") Тогда
			Запись._start = ДатаИзФорматаGoogle(Мероприятие.start.dateTime);
		КонецЕсли;
		Если Мероприятие.start.Свойство("date") Тогда
			Запись._start = ДатаИзФорматаGoogle(Мероприятие.start.date);
		КонецЕсли;
		Если Мероприятие.end.Свойство("dateTime") Тогда
			Запись._end = ДатаИзФорматаGoogle(Мероприятие.end.dateTime);
		КонецЕсли;
		Если Мероприятие.end.Свойство("date") Тогда
			Запись._end = ДатаИзФорматаGoogle(Мероприятие.end.date);
		КонецЕсли;

	
		Запись.Записать(Истина);
		
	КонецЦикла;
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСобытияКаленаря(Команда)
	//ПолучитьСобытияКаленаряНаСервере();
	 СЗ_GoogleСервисы.ПолучитьМероприятия();
КонецПроцедуры


&НаСервере
Функция ДатаВФорматеGoogle(Дата)
	Возврат Формат(Дата, "ДФ='yyyy-MM-dd''T''HH:mm:ssZ'")
КонецФункции // ДатаВФорматеЧЗ()

&НаСервере
Функция ДатаИзФорматаGoogle(ДатаGoogle)
	Возврат Дата(Лев(ДатаGoogle, 4) + Сред(ДатаGoogle, 6, 2) + Сред(ДатаGoogle, 9, 2) + Сред(ДатаGoogle, 12, 2) + Сред(ДатаGoogle, 15, 2));
КонецФункции // ДатаВФорматеЧЗ()


&НаСервере
Процедура СоздатьКалендарьНаСервере()
	СЗ_GoogleСервисы.СоздатьКалендарь();
КонецПроцедуры


&НаКлиенте
Процедура СоздатьКалендарь(Команда)
	СоздатьКалендарьНаСервере();
КонецПроцедуры

