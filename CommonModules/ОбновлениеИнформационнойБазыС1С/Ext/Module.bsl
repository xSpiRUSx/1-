﻿Процедура ПриДобавленииПодсистемы(Описание) Экспорт
//  имя конфигурации и номер версии на
 Описание.Имя = "Самозанятый1С";
 Описание.Версия = "1.0.1.1";
 // Требуется библиотека стандартных подсистем.
 Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
 КонецПроцедуры
 Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
 КонецПроцедуры
 Процедура ПередОбновлениемИнформационнойБазы() Экспорт
 КонецПроцедуры
 Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
 Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
 КонецПроцедуры
 Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
 КонецПроцедуры
 Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 КонецПроцедуры
 Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 КонецПроцедуры
 Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 КонецПроцедуры