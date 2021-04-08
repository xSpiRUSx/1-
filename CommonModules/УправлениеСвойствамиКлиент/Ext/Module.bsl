﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, что указанное событие - это событие об изменении набора свойств.
//
// Параметры:
//  Форма      - ФормаКлиентскогоПриложения - форма, в которой была вызвана обработка оповещения.
//  ИмяСобытия - Строка       - имя обрабатываемого события.
//  Параметр   - Произвольный - параметры, переданные в событии.
//             - Структура:
//                  * Ссылка - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений - измененный набор свойств.
//                           - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения - измененный дополнительный
//                                                                                             реквизит.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда это оповещение об изменении набора свойств и
//           его нужно обработать в форме.
//
Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НаборыДополнительныхРеквизитовИСведений" Тогда
		Если Не Параметр.Свойство("Ссылка") Тогда
			Возврат Истина;
		Иначе
			Возврат Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта.НайтиПоЗначению(Параметр.Ссылка) <> Неопределено;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения" Тогда
		
		Если Форма.ПараметрыСвойств.Свойство("ВыполненаОтложеннаяИнициализация")
			И Не Форма.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация
			Или Не Параметр.Свойство("Ссылка") Тогда
			Возврат Истина;
		Иначе
			Отбор = Новый Структура("Свойство", Параметр.Ссылка);
			Возврат Форма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор).Количество() > 0;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Обновляет видимость, доступность и обязательность заполнения
// дополнительных реквизитов.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения     - обрабатываемая форма.
//  Объект - ДанныеФормыСтруктура - описание объекта, к которому подключены свойства,
//                                  если свойство не указано или Неопределено, то
//                                  объект будет взят из реквизита формы "Объект".
//
Процедура ОбновитьЗависимостиДополнительныхРеквизитов(Форма, Объект = Неопределено) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Форма.Свойства_ОписаниеЗависимыхДополнительныхРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект = Неопределено Тогда
		ОписаниеОбъекта = Форма.Объект;
	Иначе
		ОписаниеОбъекта = Объект;
	КонецЕсли;
	
	Для Каждого ОписаниеЗависимогоРеквизита Из Форма.Свойства_ОписаниеЗависимыхДополнительныхРеквизитов Цикл
		Если ОписаниеЗависимогоРеквизита.ВыводитьВВидеГиперссылки Тогда
			ОбрабатываемыйЭлемент = СтрЗаменить(ОписаниеЗависимогоРеквизита.ИмяРеквизитаЗначение, "ДополнительныйРеквизитЗначение_", "Группа_");
		Иначе
			ОбрабатываемыйЭлемент = ОписаниеЗависимогоРеквизита.ИмяРеквизитаЗначение;
		КонецЕсли;
		
		Если ОписаниеЗависимогоРеквизита.УсловиеДоступности <> Неопределено Тогда
			Параметры = Новый Структура;
			Параметры.Вставить("ЗначенияПараметров", ОписаниеЗависимогоРеквизита.УсловиеДоступности.ЗначенияПараметров);
			Параметры.Вставить("Форма", Форма);
			Параметры.Вставить("ОписаниеОбъекта", ОписаниеОбъекта);
			Результат = Вычислить(ОписаниеЗависимогоРеквизита.УсловиеДоступности.КодУсловия);
			
			Элемент = Форма.Элементы[ОбрабатываемыйЭлемент];
			Если Элемент.Доступность <> Результат Тогда
				Элемент.Доступность = Результат;
			КонецЕсли;
		КонецЕсли;
		Если ОписаниеЗависимогоРеквизита.УсловиеВидимости <> Неопределено Тогда
			Параметры = Новый Структура;
			Параметры.Вставить("ЗначенияПараметров", ОписаниеЗависимогоРеквизита.УсловиеВидимости.ЗначенияПараметров);
			Параметры.Вставить("Форма", Форма);
			Параметры.Вставить("ОписаниеОбъекта", ОписаниеОбъекта);
			Результат = Вычислить(ОписаниеЗависимогоРеквизита.УсловиеВидимости.КодУсловия);
			
			Элемент = Форма.Элементы[ОбрабатываемыйЭлемент];
			Если Элемент.Видимость <> Результат Тогда
				Элемент.Видимость = Результат;
			КонецЕсли;
		КонецЕсли;
		Если ОписаниеЗависимогоРеквизита.УсловиеОбязательностиЗаполнения <> Неопределено Тогда
			Если Не ОписаниеЗависимогоРеквизита.ЗаполнятьОбязательно Тогда
				Продолжить;
			КонецЕсли;
			
			Параметры = Новый Структура;
			Параметры.Вставить("ЗначенияПараметров", ОписаниеЗависимогоРеквизита.УсловиеОбязательностиЗаполнения.ЗначенияПараметров);
			Параметры.Вставить("Форма", Форма);
			Параметры.Вставить("ОписаниеОбъекта", ОписаниеОбъекта);
			Результат = Вычислить(ОписаниеЗависимогоРеквизита.УсловиеОбязательностиЗаполнения.КодУсловия);
			
			Элемент = Форма.Элементы[ОбрабатываемыйЭлемент];
			Если Не ОписаниеЗависимогоРеквизита.ВыводитьВВидеГиперссылки
				И Элемент.АвтоОтметкаНезаполненного <> Результат Тогда
				Элемент.АвтоОтметкаНезаполненного = Результат;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет наличие зависимых дополнительных реквизитов на форме
// и при необходимости подключает обработчик ожидания проверки зависимостей реквизитов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - проверяемая форма.
//
Процедура ПослеЗагрузкиДополнительныхРеквизитов(Форма) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
		Или НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат;
	КонецЕсли;
	
	Форма.ПодключитьОбработчикОжидания("ОбновитьЗависимостиДополнительныхРеквизитов", 2);
	
КонецПроцедуры

// Обработчик команд с форм, к которым подключены дополнительные свойства.
// 
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма с дополнительными реквизитами, предварительно
//                          настроенная в процедуре УправлениеСвойствами.ПриСозданииНаСервере().
//  Элемент              - ПолеФормы
//                       - КомандаФормы - элемент, нажатие которого необходимо обработать.
//  СтандартнаяОбработка - Булево - возвращаемый параметр, если необходимо выполнить интерактивные
//                          действия с пользователем, то устанавливается в значение Ложь.
//
Процедура ВыполнитьКоманду(Форма, Элемент  = Неопределено, СтандартнаяОбработка  = Неопределено) Экспорт
	
	Если Элемент = Неопределено Тогда
		ИмяКоманды = "РедактироватьСоставДополнительныхРеквизитов";
	ИначеЕсли ТипЗнч(Элемент) = Тип("КомандаФормы") Тогда
		ИмяКоманды = Элемент.Имя;
	Иначе
		ЗначениеРеквизита = Форма[Элемент.Имя];
		Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			РедактироватьГиперссылкуРеквизита(Форма, Истина, Элемент);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ИмяКоманды = "РедактироватьСоставДополнительныхРеквизитов" Тогда
		РедактироватьСоставСвойств(Форма);
	ИначеЕсли ИмяКоманды = "РедактироватьГиперссылкуРеквизита" Тогда
		РедактироватьГиперссылкуРеквизита(Форма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьСписокСвойств(ДополнительныеРеквизиты = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура;
	Если ДополнительныеРеквизиты Тогда
		ПараметрыФормы.Вставить("ПоказатьДополнительныеРеквизиты");
	Иначе
		ПараметрыФормы.Вставить("ПоказатьДополнительныеСведения");
	КонецЕсли;
	ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка",
		ПараметрыФормы, , ?(ДополнительныеРеквизиты, "ДополнительныеРеквизиты", "ДополнительныеСведения"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму редактирования набора дополнительных реквизитов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой осуществляется вызов метода.
//
Процедура РедактироватьСоставСвойств(Форма)
	
	Наборы = Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта;
	
	Если Наборы.Количество() = 0
	 ИЛИ НЕ ЗначениеЗаполнено(Наборы[0].Значение) Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не удалось получить наборы дополнительных реквизитов объекта.
			           |
			           |Возможно у объекта не заполнены необходимые реквизиты.'"));
	
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказатьДополнительныеРеквизиты");
		
		ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка", ПараметрыФормы);
		
		ПараметрыПерехода = Новый Структура;
		ПараметрыПерехода.Вставить("Набор", Наборы[0].Значение);
		ПараметрыПерехода.Вставить("Свойство", Неопределено);
		ПараметрыПерехода.Вставить("ЭтоДополнительноеСведение", Ложь);
		
		ДлинаНачала = СтрДлина("ДополнительныйРеквизитЗначение_");
		ЭтоПолеФормы = (ТипЗнч(Форма.ТекущийЭлемент) = Тип("ПолеФормы"));
		Если ЭтоПолеФормы И ВРег(Лев(Форма.ТекущийЭлемент.Имя, ДлинаНачала)) = ВРег("ДополнительныйРеквизитЗначение_") Тогда
			
			ИдентификаторНабора   = СтрЗаменить(Сред(Форма.ТекущийЭлемент.Имя, ДлинаНачала +  1, 36), "x","-");
			ИдентификаторСвойства = СтрЗаменить(Сред(Форма.ТекущийЭлемент.Имя, ДлинаНачала + 38, 36), "x","-");
			
			Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(НРег(ИдентификаторНабора)) Тогда
				ПараметрыПерехода.Вставить("Набор", ИдентификаторНабора);
			КонецЕсли;
			
			Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(НРег(ИдентификаторСвойства)) Тогда
				ПараметрыПерехода.Вставить("Свойство", ИдентификаторСвойства);
			КонецЕсли;
		КонецЕсли;
		
		Оповестить("Переход_НаборыДополнительныхРеквизитовИСведений", ПараметрыПерехода);
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактироватьГиперссылкуРеквизита(Форма, ПереходПоГиперссылке = Ложь, Элемент = Неопределено)
	Если Не ПереходПоГиперссылке Тогда
		ИмяКнопки = Форма.ТекущийЭлемент.Имя;
		УникальнаяЧасть = СтрЗаменить(ИмяКнопки, "Кнопка_", "");
		ИмяРеквизита = "ДополнительныйРеквизитЗначение_" + УникальнаяЧасть;
	Иначе
		ИмяРеквизита = Элемент.Имя;
		УникальнаяЧасть = СтрЗаменить(ИмяРеквизита, "ДополнительныйРеквизитЗначение_", "");
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИмяРеквизитаЗначение", ИмяРеквизита);
	
	ОписаниеРеквизитов = Форма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(ПараметрыОтбора);
	Если ОписаниеРеквизитов.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	ОписаниеРеквизита = ОписаниеРеквизитов[0];
	
	Если Не ОписаниеРеквизита.СтрокаСсылочногоТипа Тогда
		Элемент = Форма.Элементы[ИмяРеквизита]; // РасширениеПоляФормыДляПоляНадписи, РасширениеПоляФормыДляПоляВвода
		Если Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
			Элемент.Вид = ВидПоляФормы.ПолеНадписи;
			Элемент.Гиперссылка = Истина;
		Иначе
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Если ОписаниеРеквизита.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
				ИЛИ ОписаниеРеквизита.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
				ПараметрВыбора = ?(ЗначениеЗаполнено(ОписаниеРеквизита.ВладелецДополнительныхЗначений),
					ОписаниеРеквизита.ВладелецДополнительныхЗначений, ОписаниеРеквизита.Свойство);
				ПараметрыВыбораМассив = Новый Массив;
				ПараметрыВыбораМассив.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ПараметрВыбора));
				
				Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораМассив);
			КонецЕсли;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяРеквизита", ИмяРеквизита);
	ПараметрыОткрытия.Вставить("ТипЗначения", ОписаниеРеквизита.ТипЗначения);
	ПараметрыОткрытия.Вставить("НаименованиеРеквизита", ОписаниеРеквизита.Наименование);
	ПараметрыОткрытия.Вставить("СтрокаСсылочногоТипа", ОписаниеРеквизита.СтрокаСсылочногоТипа);
	ПараметрыОткрытия.Вставить("ЗначениеРеквизита", Форма[ИмяРеквизита]);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	Если ОписаниеРеквизита.СтрокаСсылочногоТипа Тогда
		ПараметрыОткрытия.Вставить("ИмяРеквизитаСсылки", "СсылочныйДополнительныйРеквизитЗначение_" + УникальнаяЧасть);
	Иначе
		ПараметрыОткрытия.Вставить("Свойство", ОписаниеРеквизита.Свойство);
		ПараметрыОткрытия.Вставить("ВладелецДополнительныхЗначений", ОписаниеРеквизита.ВладелецДополнительныхЗначений);
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьГиперссылкуРеквизитаЗавершение", УправлениеСвойствамиКлиент, Форма);
	ОткрытьФорму("ОбщаяФорма.РедактированиеГиперссылки", ПараметрыОткрытия,,,,, ОписаниеОповещения);
КонецПроцедуры

Процедура РедактироватьГиперссылкуРеквизитаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры;
	Форма[Результат.ИмяРеквизита] = Результат.Значение;
	Если Результат.СтрокаСсылочногоТипа Тогда
		Форма[Результат.ИмяРеквизитаСсылки] = Результат.ФорматированнаяСтрока;
	КонецЕсли;
	Форма.Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти