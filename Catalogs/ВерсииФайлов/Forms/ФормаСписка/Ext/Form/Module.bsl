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
	
	// Оформление помеченных на удаление.
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	РаботаСФайламиСлужебный.УстановитьОтборПоПометкеУдаления(Список.Отбор);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.СписокКомментарий.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
	   И Параметр.Свойство("Событие")
	   И (    Параметр.Событие = "ЗаконченоРедактирование"
	      ИЛИ Параметр.Событие = "ВерсияСохранена") Тогда
		
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ВладелецФайла(ВыбраннаяСтрока), ВыбраннаяСтрока, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(Элементы.Список.ТекущаяСтрока);
	Если ДанныеФайла.ТекущаяВерсия = Элементы.Список.ТекущаяСтрока Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Активную версию нельзя удалить.'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьКарточкуФайла();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ИзменитьДоступностьКоманд();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.УдалитьДанные(
		Новый ОписаниеОповещения("ПослеУдаленияДанных", ЭтотОбъект),
		Элементы.Список.ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПомеченныеФайлы(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ИзменитьОтборПоПометкеУдаления(Список.Отбор, Элементы.ПоказыватьПомеченныеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьДоступностьКоманд()
	
	АвторТекущийПользователь =
		Элементы.Список.ТекущиеДанные.Автор = ПользователиКлиент.АвторизованныйПользователь();
	
	Элементы.ФормаУдалить.Доступность = АвторТекущийПользователь;
	Элементы.СписокКонтекстноеМенюУдалить.Доступность = АвторТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуФайла()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВладелецФайла(ВыбраннаяСтрока)
	Возврат ВыбраннаяСтрока.Владелец;
КонецФункции

#КонецОбласти