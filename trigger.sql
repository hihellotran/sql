select * from [Order Details]
--kh�ng cho x�a order details n�o c� discount kh�c 0 

go
create trigger dis on [Order Details] for delete 
as
begin
		if exists(select * from deleted where Discount!=0)
		begin 
			print('Can not delete')
			rollback tran
		end
end 

delete [Order Details] where OrderID= '10250' and ProductID = '51'