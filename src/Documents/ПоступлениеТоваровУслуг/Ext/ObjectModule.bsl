﻿Процедура РасчетСуммыДокумента() Экспорт

	СуммаДокумента = Товары.Итог("Сумма")+Услуги.Итог("Сумма");	

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	РасчетСуммыДокумента();
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	СУММА(ПоступлениеТоваровУслугТовары.Количество) КАК Количество,
		|	ПоступлениеТоваровУслугТовары.Ссылка.Склад,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	ПоступлениеТоваровУслугТовары.Ссылка.Дата КАК Период
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Ссылка.Склад,
		|	ПоступлениеТоваровУслугТовары.Ссылка.Дата";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	Если Не ПолучитьФункциональнуюОпцию("УчетПоСкладам") Тогда
		
		ТаблицаЗначений.ЗаполнитьЗначения(Справочники.Склады.ПустаяСсылка(), "Склад");		
	
	КонецЕсли;
		
	Движения.ТоварыНаСкладах.Загрузить(ТаблицаЗначений);
	Движения.ТоварыНаСкладах.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	// Начиная с версии 8.2 обработчик ОбработкаЗаполнения срабатывает не только
	//при вводе на основании, но и при создании нового объекта и для причины
	//срабатывания этого обработчика необходимо проанализировать ДанныеЗаполнения.
	
	// В данном случае анализировать ДанныеЗаполнения не нужно т.к. для данного документа 
	//ввод на основании не настроен.
	
	// Так же можно не проверять на копирование и на новый т.к. при копировании и для не нового объекта
	//данный обработчик не срабатывает.
	Склад = ХранилищеОбщихНастроек.Загрузить("ОсновнойСклад");
	
КонецПроцедуры

