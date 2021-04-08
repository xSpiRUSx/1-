﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СохранятьСРасшифровкой = 1;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		МодульЭлектроннаяПодпись = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодпись");
		
		РасширениеДляЗашифрованныхФайлов =
			МодульЭлектроннаяПодпись.ПерсональныеНастройки().РасширениеДляЗашифрованныхФайлов;
	Иначе
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранятьСРасшифровкой", "ВидПереключателя", ВидПереключателя.Переключатель);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСохранитьФайл", "Отображение", ОтображениеКнопки.Картинка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтмена", "Видимость", Ложь);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СохранятьСРасшифровкой", СохранятьСРасшифровкой);
	СтруктураВозврата.Вставить("РасширениеДляЗашифрованныхФайлов", РасширениеДляЗашифрованныхФайлов);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти
