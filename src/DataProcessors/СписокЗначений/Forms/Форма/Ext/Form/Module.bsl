﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для А=1 По 5000 Цикл
		СписокЗначений.Добавить("Объект "+А);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстныйВызовСИзменениемДанных(Команда)
	КонтекстныйВызовСИзменениемДанныхНаСервере();
КонецПроцедуры

&НаСервере
Процедура КонтекстныйВызовСИзменениемДанныхНаСервере()
	Реквизит1 = Реквизит1+"а";
КонецПроцедуры

&НаКлиенте
Процедура КонтекстныйВызовБезИзмененияДанных(Команда)
	КонтекстныйВызовБезИзмененияДанныхНаСервере();
КонецПроцедуры

&НаСервере
Процедура КонтекстныйВызовБезИзмененияДанныхНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПередачаЧерезПараметр(Команда)
	ПередачаЧерезПараметрНаСервере(СписокЗначений);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПередачаЧерезПараметрНаСервере(СписокЗначений)
	// Вставить содержимое обработчика.
КонецПроцедуры

