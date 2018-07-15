﻿
&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Организация") Тогда
		
		ПараметрыФО = Новый Структура;
		ПараметрыФО.Вставить("Организация", Параметры.Организация);
		
		Если Параметры.Свойство("Дата") Тогда
			
			ПараметрыФО.Вставить("Период", Параметры.Дата);			
		
		КонецЕсли;
		
		ВыпускПродукции = ПолучитьФункциональнуюОпцию("ВыпускПродукции", ПараметрыФО);
		
		Если Не ВыпускПродукции Тогда
		
			Если Параметры.Отбор.Свойство("ВидНоменклатуры") Тогда
				
				Если ТипЗнч(Параметры.Отбор.ВидНоменклатуры) = Тип("ФиксированныйМассив") Тогда
				
					МассивВидовНоменклатуры = Новый Массив(Параметры.Отбор.ВидНоменклатуры);
					Индекс = МассивВидовНоменклатуры.Найти(Перечисления.ВидыНоменклатуры.Продукция);
					
					Если Индекс<>Неопределено Тогда
					
						МассивВидовНоменклатуры.Удалить(Индекс);
						Параметры.Отбор.ВидНоменклатуры = МассивВидовНоменклатуры;
					
					КонецЕсли;
					
				ИначеЕсли Параметры.Отбор.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Продукция Тогда
					
					Сообщить("Выбор продукции запрещен для данной организации!");
					Отказ = Истина;
					Возврат;
				
				КонецЕсли;				
				
			Иначе
				
				МассивВидовНоменклатуры = Новый Массив();
				МассивВидовНоменклатуры.Добавить(Перечисления.ВидыНоменклатуры.Товар);
				МассивВидовНоменклатуры.Добавить(Перечисления.ВидыНоменклатуры.Материал);
				МассивВидовНоменклатуры.Добавить(Перечисления.ВидыНоменклатуры.Услуга);
				
				Параметры.Отбор.Вставить("ВидНоменклатуры", МассивВидовНоменклатуры);
			
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Склад = Параметры.Склад;
	
	Список.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимыОткрытияФормы(Команда)
	
	//ОткрытьФорму("Отчет.НастройкиКомпоновкиДанных.Форма",,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	ОткрытьФормуМодально("Отчет.НастройкиКомпоновкиДанных.Форма",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Тест(Команда)
	ТестНаСервере();
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТестНаСервере()
	
	НастройкиНачальнойСтраницы = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиНачальнойСтраницы");
	СоставФорм = НастройкиНачальнойСтраницы.ПолучитьСоставФорм();
	НастройкиНачальнойСтраницы.УстановитьСоставФорм(СоставФорм);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы",,НастройкиНачальнойСтраницы);
	
КонецПроцедуры








