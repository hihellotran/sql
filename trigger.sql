select * from [Order Details]
--không cho xóa order details nào có discount khác 0 

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