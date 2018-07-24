﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МВТ = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	СУММА(РеализацияТоваровУслугТовары.Количество) КАК Количество,
		|	РеализацияТоваровУслугТовары.Ссылка.Склад,
		|	РеализацияТоваровУслугТовары.Ссылка.Дата КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	МАКСИМУМ(РеализацияТоваровУслугТовары.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РеализацияТоваровУслугТовары.Ссылка.Склад,
		|	РеализацияТоваровУслугТовары.Ссылка.Дата,
		|	РеализацияТоваровУслугТовары.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.Номенклатура,
		|	ВТ_Товары.Количество,
		|	ВТ_Товары.Склад,
		|	ВТ_Товары.Период,
		|	ВТ_Товары.ВидДвижения
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары";
		
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Движения.ТоварыНаСкладах.Загрузить(РезультатЗапроса.Выгрузить());
	Движения.ТоварыНаСкладах.БлокироватьДляИзменения = Истина;
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.Записать();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВТ_Товары.Номенклатура,
		|	ВТ_Товары.Склад,
		|	ВТ_Товары.НомерСтроки,
		|	-ТоварыНаСкладахОстатки.КоличествоОстаток КАК Недостача
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&ГраницаВключая, ) КАК ТоварыНаСкладахОстатки
		|		ПО ВТ_Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
		|ГДЕ
		|	ТоварыНаСкладахОстатки.КоличествоОстаток < 0";
	
	Запрос.УстановитьПараметр("ГраницаВключая", Новый Граница(МоментВремени(),ВидГраницы.Включая));
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не хватает товара "+ВыборкаДетальныеЗаписи.Номенклатура+". Недостача - "+ВыборкаДетальныеЗаписи.Недостача+".";
		Сообщение.Поле = "Товары["+(ВыборкаДетальныеЗаписи.НомерСтроки-1)+"].Количество";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
	КонецЦикла;
	
	Если Не Отказ Тогда
		
		Движение = Движения.Взаиморасчеты.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Сумма = СуммаДокумента;
		
		Движения.Взаиморасчеты.Записывать = Истина;	
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	//Если в свойстве ДополнительныеСвойства присутствует ключ "СтандартноеЗаполнение"
	//значит процедура вызвана нами программно в таком случае необходимо удалить ключ
	//и завершить процедуру чтобы отработал стандартный механизм заполнения
	Если ДополнительныеСвойства.Свойство("СтандартноеЗаполнение") Тогда
		ДополнительныеСвойства.Удалить("СтандартноеЗаполнение");
		Возврат;
		
	КонецЕсли;
	
	// Т.к начиная с версии 8.2 обработчик ОбработкаЗаполнения вызывается не только при вводе на основании,
	//но и при создании нового объекта, то чтобы понять что послужило причиной вызова
	//необходимо проанализировать ДанныеЗаполнения
	//Там может находиться либо Неопределено, либо структура отбора (только с видом сравнения Равно) 
	//установленного на форме списка из которой создавался новый документ
	
	// Вместо того чтобы при помощи условий разделять механизм ввода на основании и механизм
	//первоначального заполнения их можно грамотно объединить. Например после отработки 
	//механизма ввода на основании можно дозаполнить поля (если они остались не заполнены)
	//Для этого закомментим условие, перенесем в конец и модифицируем.
	//Если ДанныеЗаполнения = Неопределено Или ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
	//	Склад = ХранилищеОбщихНастроек.Загрузить("ОсновнойСклад");
	//КонецЕсли;
	
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		// Заполнение шапки
		Договор = ДанныеЗаполнения.Договор;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Менеджер = ДанныеЗаполнения.Менеджер;
		Организация = ДанныеЗаполнения.Организация;
		Склад = ДанныеЗаполнения.Склад;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
		КонецЦикла;
		Для Каждого ТекСтрокаУслуги Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = Услуги.Добавить();
			НоваяСтрока.Количество = ТекСтрокаУслуги.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаУслуги.Номенклатура;
			НоваяСтрока.Сумма = ТекСтрокаУслуги.Сумма;
			НоваяСтрока.Цена = ТекСтрокаУслуги.Цена;
		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	
	//Как мы помним ДанныеЗаполнения могут содержать структуру установленного на форме списка отбора 
	//с элементами с видом сравнения Равно. Ее можно использовать для программного заполнения, а так же
	//можно в свойствах реквизита объекта установить галку в свойство Заполнять из данных заполнения и тогда
	//такой реквизит будет заполняться без явного указания в коде. 
	//Этот механизм срабатывает после обработки заполнения
	//Имеется возможности на него повлиять:
	//1. Установив СтандартнаяОбработка в Ложь можно отключить этот механизм
	//2. Можно удалить соответствующее свойство из структуры ДанныеЗаполнения
	//На практике же отменять работу этого мехнизма большой необходимости нет.
	
	//НОВОЕ!!!
	//Механизм заполнения из данных заполнения НЕ перезаполняет поля если они были уже заполнены!!!
	//и приоритет следующий:
	// 1.Заполнение на основании
	// 2.Оставшиеся незаполненными поля из сохраненных настроек
	// 3.Оставшиеся незаполненными из структуры ДанныеЗаполнения
	
	//Задача установить приоритет заполнения.
	// 1. Заполнение на основании
	// 2. Заполнение из структуры ДанныеЗаполнения
	// 3. И только в последнюю очередь сохраненными настройками
	
	//В простом случае это можно сделать внеся код проверки и заполнения перед заполнением из
	//сохраненных настроек:
	
	//Проверим что если в данных заполнения Структура, то тогда заполним из нее
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		//ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		//В данной реализации не анализируется свойство "Заполнять из данных заполнения" и заполнены будут все поля.
		//поэтому мы ее закомментим и реализуем иначе.
		
		//Теперь мы вызовем обработку заполнения (процедуру в которой мы сейчас находимся) 
		//программно методом объекта Заполнить() чтобы отработал штатный механизм заполнения.
		//У нас появляется необходимость анализировать была ли процедура вызвана искуственно.
		//Для этого воспользуемся свойством объекта ДополнительныеСвойства
		ДополнительныеСвойства.Вставить("СтандартноеЗаполнение");
		Заполнить(ДанныеЗаполнения);
		СтандартнаяОбработка = Ложь;
		
		
	КонецЕсли;
	
	
	//Проверим после отработки ввода на основании заполнено ли поле склад и если нет, то заполним его
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Склад = ХранилищеОбщихНастроек.Загрузить("ОсновнойСклад");
	КонецЕсли;
	
КонецПроцедуры










