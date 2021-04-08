﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Работа с шаблонами офисных документов.

// Получает за один вызов всю необходимую информацию для печати: данные объектов по макетам, двоичные
// данные макетов, описание областей макетов.
// Для вызова из клиентских модулей печати форм по макетам офисных документов.
//
// Параметры:
//   ИмяМенеджераПечати - Строка - имя для обращения к менеджеру объекта, например "Документ.<Имя документа>".
//   ИменаМакетов       - Строка - имена макетов, по которым будут формироваться печатные формы.
//   СоставДокументов   - Массив - ссылки на объекты информационной базы (должны быть одного типа).
//
// Возвращаемое значение:
//  Соответствие - коллекция ссылок на объекты и их данные:
//   * Ключ - ЛюбаяСсылка - ссылка на объект информационной базы;
//   * Значение - Структура:
//       ** Ключ - Строка - имя макета;
//       ** Значение - Структура - данные объекта.
//
Функция МакетыИДанныеОбъектовДляПечати(Знач ИмяМенеджераПечати, Знач ИменаМакетов, Знач СоставДокументов) Экспорт
	
	Возврат УправлениеПечатью.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати, ИменаМакетов, СоставДокументов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сформировать печатные формы для непосредственного вывода на принтер.
//
// Подробнее - см. описание УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечати().
//
Функция СформироватьПечатныеФормыДляБыстройПечати(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов,	ПараметрыПечати) Экспорт
	
	Возврат УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечати(ИмяМенеджераПечати, ИменаМакетов,
		МассивОбъектов,	ПараметрыПечати);
	
КонецФункции

// Сформировать печатные формы для непосредственного вывода на принтер в обычном приложении.
//
// Подробнее - см. описание УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение().
//
Функция СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати) Экспорт
	
	Возврат УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(ИмяМенеджераПечати, ИменаМакетов,
		МассивОбъектов,	ПараметрыПечати);
	
КонецФункции

// Возвращает истину, если есть право проведения хотя бы для одного документа.
Функция ДоступноПравоПроведения(СписокДокументов) Экспорт
	Возврат СтандартныеПодсистемыСервер.ДоступноПравоПроведения(СписокДокументов);
КонецФункции

// См. УправлениеПечатью.ПакетДокументов.
Функция ПакетДокументов(ТабличныеДокументы, ОбъектыПечати, ПечататьКомплектами, КоличествоЭкземпляров = 1) Экспорт
	
	Возврат УправлениеПечатью.ПакетДокументов(ТабличныеДокументы, ОбъектыПечати,
		ПечататьКомплектами, КоличествоЭкземпляров);
	
КонецФункции

#КонецОбласти
