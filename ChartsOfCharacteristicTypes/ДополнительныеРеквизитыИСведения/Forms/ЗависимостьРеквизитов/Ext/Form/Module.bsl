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
	
	УстановитьУсловноеОформление();
	
	НастраиваемоеСвойство = Параметры.НастраиваемоеСвойство;
	
	СвойстваОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ДополнительныйРеквизит, "Заголовок");
	
	Заголовок = НСтр("ru = '%1 дополнительного реквизита ""%2""'");
	Если НастраиваемоеСвойство = "Доступен" Тогда
		ПредставлениеСвойства = НСтр("ru = 'Доступность'");
	ИначеЕсли НастраиваемоеСвойство = "ЗаполнятьОбязательно" Тогда
		ПредставлениеСвойства = НСтр("ru = 'Обязательность заполнения'");
	Иначе
		ПредставлениеСвойства = НСтр("ru = 'Видимость'");
	КонецЕсли;
	Заголовок = СтрЗаменить(Заголовок, "%1", ПредставлениеСвойства);
	Заголовок = СтрЗаменить(Заголовок, "%2", СвойстваОбъекта.Заголовок);
	
	Если Не ЗначениеЗаполнено(СвойстваОбъекта.Заголовок)  Тогда
		Заголовок = СтрЗаменить(Заголовок, """", "");
	КонецЕсли;
	
	НаборСвойств = Параметры.Набор;
	
	Если Не ЗначениеЗаполнено(НаборСвойств) Тогда
		ТекстИсключения = НСтр("ru = 'Настройка видимости, доступности и обязательности заполнения
			              |доступна только при открытии дополнительного реквизита
			              |из списка ""Дополнительные реквизиты"".'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, Символы.ПС, " ");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НаборСвойств, "Родитель");
	Если Не ЗначениеЗаполнено(Родитель) Тогда
		Родитель = НаборСвойств;
	КонецЕсли;
	
	НаборДополнительныхРеквизитов = Родитель.ДополнительныеРеквизиты;
	
	ПредопределенныеНаборыСвойств = УправлениеСвойствамиПовтИсп.ПредопределенныеНаборыСвойств();
	ОписаниеНабора = ПредопределенныеНаборыСвойств.Получить(Родитель); // см. Справочники.НаборыДополнительныхРеквизитовИСведений.СвойстваНабора
	Если ОписаниеНабора = Неопределено Тогда
		ИмяПредопределенныхДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенныхДанных");
	Иначе
		ИмяПредопределенныхДанных = ОписаниеНабора.Имя;
	КонецЕсли;
	
	ПозицияЗаменяемогоСимвола = СтрНайти(ИмяПредопределенныхДанных, "_");
	ПолноеИмяОбъектаМетаданных = Лев(ИмяПредопределенныхДанных, ПозицияЗаменяемогоСимвола - 1)
		                       + "."
		                       + Сред(ИмяПредопределенныхДанных, ПозицияЗаменяемогоСимвола + 1);
	
	РеквизитыОбъекта = СписокРеквизитовДляОтбора(ПолноеИмяОбъектаМетаданных, НаборДополнительныхРеквизитов);
	
	СтрокаОтбора = Неопределено;
	ЗависимостиДополнительныхРеквизитов = Параметры.ЗависимостиРеквизитов;
	Для Каждого СтрокаТабличнойЧасти Из ЗависимостиДополнительныхРеквизитов Цикл
		Если СтрокаТабличнойЧасти.НаборСвойств <> НаборСвойств Тогда
			Продолжить;
		КонецЕсли;
		Если СтрокаТабличнойЧасти.ЗависимоеСвойство = НастраиваемоеСвойство Тогда
			УсловиеЧастями = СтрРазделить(СтрокаТабличнойЧасти.Условие, " ");
			НовоеУсловие = "";
			Если УсловиеЧастями.Количество() > 0 Тогда
				Для Каждого ЧастьУсловия Из УсловиеЧастями Цикл
					НовоеУсловие = НовоеУсловие + ВРег(Лев(ЧастьУсловия, 1)) + Сред(ЧастьУсловия, 2);
				КонецЦикла;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НовоеУсловие) Тогда
				СтрокаТабличнойЧасти.Условие = НовоеУсловие;
			КонецЕсли;
			
			РеквизитСМножественнымЗначением = (СтрокаТабличнойЧасти.Условие = "ВСписке")
				Или (СтрокаТабличнойЧасти.Условие = "НеВСписке");
			
			Если РеквизитСМножественнымЗначением Тогда
				ПараметрыОтбора = Новый Структура;
				ПараметрыОтбора.Вставить("Реквизит", СтрокаТабличнойЧасти.Реквизит);
				ПараметрыОтбора.Вставить("Условие",  СтрокаТабличнойЧасти.Условие);
				
				РезультатПоиска = ЗависимостиРеквизитов.НайтиСтроки(ПараметрыОтбора);
				Если РезультатПоиска.Количество() = 0 Тогда
					СтрокаОтбора = ЗависимостиРеквизитов.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаОтбора, СтрокаТабличнойЧасти,, "Значение");
					
					Значения = Новый СписокЗначений;
					Значения.Добавить(СтрокаТабличнойЧасти.Значение);
					СтрокаОтбора.Значение = Значения;
				Иначе
					СтрокаОтбора = РезультатПоиска[0];
					СтрокаОтбора.Значение.Добавить(СтрокаТабличнойЧасти.Значение);
				КонецЕсли;
			Иначе
				СтрокаОтбора = ЗависимостиРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаОтбора, СтрокаТабличнойЧасти);
			КонецЕсли;
			
			ОписаниеРеквизита = РеквизитыОбъекта.Найти(СтрокаОтбора.Реквизит, "Реквизит");
			Если ОписаниеРеквизита = Неопределено Тогда
				Продолжить; // Реквизит объекта не найден.
			КонецЕсли;
			СтрокаОтбора.РежимВыбора   = ОписаниеРеквизита.РежимВыбора;
			СтрокаОтбора.Представление = ОписаниеРеквизита.Представление;
			СтрокаОтбора.ТипЗначения   = ОписаниеРеквизита.ТипЗначения;
			Если РеквизитСМножественнымЗначением Тогда
				СтрокаОтбора.Значение.ТипЗначения = ОписаниеРеквизита.ТипЗначения;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Свойства_ВыборРеквизитаОбъекта" Тогда
		ТекущаяСтрока = ЗависимостиРеквизитов.НайтиПоИдентификатору(Элементы.ЗависимостиРеквизитов.ТекущаяСтрока);
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Реквизит", Параметр.Реквизит);
		НайденныеСтроки = ЗависимостиРеквизитов.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.ЗависимостиРеквизитов.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
			ЗависимостиРеквизитов.Удалить(ТекущаяСтрока);
			Возврат;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Параметр);
		ТекущаяСтрока.НаборСвойств = НаборСвойств;
		ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения();
		ТекущаяСтрока.ЗависимоеСвойство = НастраиваемоеСвойство;
		ТекущаяСтрока.Условие  = "Равно";
		ТекущаяСтрока.Значение = ТекущаяСтрока.ТипЗначения.ПривестиЗначение(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗависимостиРеквизитовРеквизитНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораРеквизита();
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовПередНачаломИзменения(Элемент, Отказ)
	ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовВидСравненияПриИзменении(Элемент)
	ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения();
	
	ТаблицаФормы = Элементы.ЗависимостиРеквизитов;
	ТекущаяСтрока = ЗависимостиРеквизитов.НайтиПоИдентификатору(ТаблицаФормы.ТекущаяСтрока);
	
	Если ТаблицаФормы.ТекущиеДанные.Условие = "ВСписке"
		Или ТаблицаФормы.ТекущиеДанные.Условие = "НеВСписке" Тогда
		Если ТипЗнч(ТекущаяСтрока.Значение) <> Тип("СписокЗначений") Тогда
			СтароеЗначение = ТекущаяСтрока.Значение;
			ТекущаяСтрока.Значение = Новый СписокЗначений;
			ТекущаяСтрока.Значение.ТипЗначения = ТаблицаФормы.ТекущиеДанные.ТипЗначения;
			Если ЗначениеЗаполнено(СтароеЗначение) Тогда
				ТекущаяСтрока.Значение.Добавить(СтароеЗначение);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТаблицаФормы.ТекущиеДанные.Условие = "Равно"
		Или ТаблицаФормы.ТекущиеДанные.Условие = "НеРавно" Тогда
		Если ТипЗнч(ТекущаяСтрока.Значение) = Тип("СписокЗначений")
			И ТекущаяСтрока.Значение.Количество() > 0 Тогда
			ТекущаяСтрока.Значение = ТекущаяСтрока.Значение[0].Значение;
		КонецЕсли;
	Иначе
		ТекущаяСтрока.Значение = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не ДобавлениеСтроки Тогда
		Отказ = Истина;
	Иначе
		ОткрытьФормуВыбораРеквизита();
		ДобавлениеСтроки = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораРеквизита()
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РеквизитыОбъекта", РеквизитыОбъектаВХранилище);
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ВыборРеквизита", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьУсловие(Команда)
	ДобавлениеСтроки = Истина;
	Элементы.ЗависимостиРеквизитов.ДобавитьСтроку();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОк(Команда)
	Результат = Новый Структура;
	Результат.Вставить(НастраиваемоеСвойство, НастройкиОтбораВХранилищеЗначений());
	Оповестить("Свойства_УстановленаЗависимостьРеквизита", Результат);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НастройкиОтбораВХранилищеЗначений()
	
	Если ЗависимостиРеквизитов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиРеквизитов");
	КопияТаблицы = ТаблицаЗависимостей.Скопировать();
	КопияТаблицы.Колонки.Удалить("Представление");
	КопияТаблицы.Колонки.Удалить("ТипЗначения");
	
	ПараметрОтбора = Новый Структура;
	ПараметрОтбора.Вставить("Условие", "ВСписке");
	ПреобразоватьЗависимостиВСписке(КопияТаблицы, ПараметрОтбора);
	ПараметрОтбора.Условие = "НеВСписке";
	ПреобразоватьЗависимостиВСписке(КопияТаблицы, ПараметрОтбора);
	
	Возврат Новый ХранилищеЗначения(КопияТаблицы);
	
КонецФункции

&НаСервере
Процедура ПреобразоватьЗависимостиВСписке(Таблица, Отбор)
	НайденныеСтроки = Таблица.НайтиСтроки(Отбор);
	Для Каждого Строка Из НайденныеСтроки Цикл
		Для Каждого Элемент Из Строка.Значение Цикл
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.Значение = Элемент.Значение;
		КонецЦикла;
		Таблица.Удалить(Строка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СписокРеквизитовДляОтбора(ПолноеИмяОбъектаМетаданных, НаборДополнительныхРеквизитов)
	
	РеквизитыОбъекта = Новый ТаблицаЗначений;
	РеквизитыОбъекта.Колонки.Добавить("Реквизит");
	РеквизитыОбъекта.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	РеквизитыОбъекта.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов);
	РеквизитыОбъекта.Колонки.Добавить("НомерКартинки", Новый ОписаниеТипов("Число"));
	РеквизитыОбъекта.Колонки.Добавить("РежимВыбора", Новый ОписаниеТипов("ИспользованиеГруппИЭлементов"));
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Для Каждого ДополнительныйРеквизит Из НаборДополнительныхРеквизитов Цикл
		СвойстваОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДополнительныйРеквизит.Свойство, "Наименование, ТипЗначения");
		СтрокаРеквизит = РеквизитыОбъекта.Добавить();
		СтрокаРеквизит.Реквизит = ДополнительныйРеквизит.Свойство;
		СтрокаРеквизит.Представление = СвойстваОбъекта.Наименование;
		СтрокаРеквизит.НомерКартинки  = 2;
		СтрокаРеквизит.ТипЗначения = СвойстваОбъекта.ТипЗначения;
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Истина);
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Ложь);
	КонецЦикла;
	
	РеквизитыОбъекта.Сортировать("Представление Возр");
	
	РеквизитыОбъектаВХранилище = ПоместитьВоВременноеХранилище(РеквизитыОбъекта, УникальныйИдентификатор);
	
	Возврат РеквизитыОбъекта;
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Стандартный)
	СтрокаРеквизит = РеквизитыОбъекта.Добавить();
	СтрокаРеквизит.Реквизит = Реквизит.Имя;
	СтрокаРеквизит.Представление = Реквизит.Представление();
	СтрокаРеквизит.НомерКартинки  = 1;
	СтрокаРеквизит.ТипЗначения = Реквизит.Тип;
	Если Стандартный Тогда
		СтрокаРеквизит.РежимВыбора = ?(Реквизит.Имя = "Родитель", ИспользованиеГруппИЭлементов.Группы, Неопределено);
	Иначе
		СтрокаРеквизит.РежимВыбора = Реквизит.ВыборГруппИЭлементов;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения()
	
	ТаблицаФормы = Элементы.ЗависимостиРеквизитов;
	ПолеВвода    = Элементы.ЗависимостиРеквизитовПравоеЗначение;
	
	ПараметрыВыбораМассив = Новый Массив;
	Если ТипЗнч(ТаблицаФормы.ТекущиеДанные.Реквизит) <> Тип("Строка") Тогда
		ПараметрыВыбораМассив.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ТаблицаФормы.ТекущиеДанные.Реквизит));
	КонецЕсли;
	
	РежимВыбора = ТаблицаФормы.ТекущиеДанные.РежимВыбора;
	Если РежимВыбора = ИспользованиеГруппИЭлементов.Группы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.Группы;
	ИначеЕсли РежимВыбора = ИспользованиеГруппИЭлементов.Элементы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
	ИначеЕсли РежимВыбора = ИспользованиеГруппИЭлементов.ГруппыИЭлементы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.ГруппыИЭлементы;
	КонецЕсли;
	
	ПолеВвода.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораМассив);
	Если ТаблицаФормы.ТекущиеДанные.Условие = "ВСписке"
		Или ТаблицаФормы.ТекущиеДанные.Условие = "НеВСписке" Тогда
		ПолеВвода.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
	Иначе
		ПолеВвода.ОграничениеТипа = ТаблицаФормы.ТекущиеДанные.ТипЗначения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементДоступность = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Доступность");
	ЭлементДоступность.Значение = Ложь;
	ЭлементДоступность.Использование = Истина;
	
	ЗначенияСравнения = Новый СписокЗначений;
	ЗначенияСравнения.Добавить("Заполнено");
	ЗначенияСравнения.Добавить("НеЗаполнено"); // исключение, является идентификатором.
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = ЗначенияСравнения;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитовПравоеЗначение");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "НеРавно";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не равно'"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "Равно";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Равно'"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "НеЗаполнено";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не заполнено'"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "Заполнено";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Заполнено'"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ВСписке";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'В списке'"));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗависимостиРеквизитовВидСравнения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "НеВСписке";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не в списке'"));
	
КонецПроцедуры

#КонецОбласти
