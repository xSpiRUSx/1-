
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Задача КАК Задача,
	|	ВзаиморасчетыОстатки.СуммаОстаток КАК СуммаОстаток
	|ИЗ
	|	РегистрНакопления.Взаиморасчеты.Остатки(, Контрагент = &Контрагент) КАК ВзаиморасчетыОстатки
	|ГДЕ
	|	ВзаиморасчетыОстатки.СуммаОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВзаиморасчетыОстатки.Задача.ДатаНачала";
	
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СуммаКОплате = Объект.Сумма;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() И СуммаКОплате > 0  Цикл
		Если ВыборкаДетальныеЗаписи.СуммаОстаток = 0 Тогда
			Продолжить
		КонецЕсли;
		
		НоваяСтрока = Объект.РасшифровкаПлатежа.Добавить();
		НоваяСтрока.Заказ = ВыборкаДетальныеЗаписи.Задача;
		НоваяСтрока.Сумма = ?(СуммаКОплате >= ВыборкаДетальныеЗаписи.СуммаОстаток, ВыборкаДетальныеЗаписи.СуммаОстаток, СуммаКОплате);
		
		СуммаКОплате = СуммаКОплате - НоваяСтрока.Сумма;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры
