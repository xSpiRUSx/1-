﻿
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ТехническоеЗадание = ТекущийОбъект.ХранилищеТехническогоЗадания.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ХранилищеТехническогоЗадания = Новый ХранилищеЗначения(ТехническоеЗадание)
КонецПроцедуры

&НаСервере
Процедура ЗатратыВремениПриИзмененииНаСервере()
	
	ЧасоваяСтавка = ОбщегоНазначенияСЗ.ПолучитьЧасовуюСтавку(Объект.Заказчик, Объект.Дата);
	Объект.СуммаЗаказа = Объект.ЗатратыВремени * ЧасоваяСтавка;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыВремениПриИзменении(Элемент)
	ЗатратыВремениПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПремияШтрафПриИзменении(Элемент)
	Объект.СуммаЗаказа = Объект.СуммаЗаказа + Объект.ПремияШтраф;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Проект = Справочники.Проекты.РазовыеЗадачи;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Отказ И ТекущийОбъект.Статус.Закрыта И НЕ ЗначениеЗаполнено(ТекущийОбъект.ДатаЗавершения) Тогда
		ТекущийОбъект.ДатаЗавершения = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры



