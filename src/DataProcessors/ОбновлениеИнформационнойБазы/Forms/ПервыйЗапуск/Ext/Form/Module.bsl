﻿
&НаКлиенте
Процедура НастройкаВыполнена(Команда)
	
	НастройкаВыполненаНаСервере();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастройкаВыполненаНаСервере()
	
	Константы.ВерсияИБ.Установить(Метаданные.Версия);
	НастройкиНачальнойСтраницы = Новый НастройкиНачальнойСтраницы;
	СоставФорм = Новый СоставФормНачальнойСтраницы;
	СоставФорм.ЛеваяКолонка.Добавить("Документ.РеализацияТоваровУслуг.Форма.ФормаСписка");
	СоставФорм.ПраваяКолонка.Добавить("Документ.ПоступлениеТоваровУслуг.Форма.ФормаСписка");
	НастройкиНачальнойСтраницы.УстановитьСоставФорм(СоставФорм);
	
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", , НастройкиНачальнойСтраницы);
	
КонецПроцедуры
