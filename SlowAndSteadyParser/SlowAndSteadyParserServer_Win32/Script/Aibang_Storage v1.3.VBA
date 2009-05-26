'//////// �������ű� For Aibang /////////
'//////// Ver 1.3            /////////
'===== Scirpt Start ======
Dim City As String
Dim Poi As String
Dim Category As String
Dim AibangId As String

Dim Name As String
Dim Phone As String
Dim Address As String
Dim WWW As String
Dim Count As Integer

Dim IsExist As Boolean

Dim Datalist As List(Of NameValueCollection)
Dim rnd As New Random()
Dim i As Double

Dim strsqlcmd As String
Dim cn As OleDbConnection
Dim cmd As OleDbCommand

'��Task��ȡ������
City = Task.GetHashString("City")
Poi = Task.GetHashString("Poi")
Category = Task.GetHashString("Category")
Count = Task.GetHashInt("Count")
Datalist = Task.GetHashValue("Datalist")
i = 1
Try
	'�����ݿ�����
	cn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=AibangPOI.MDB;")
	cn.Open()
	'��Datalist��ȡ��ÿһ��Data
	For Each Data As NameValueCollection In Datalist
		'�����ݴ������
		Name = Data("Name")
		Phone = Data("Phone")
		Address = Data("Address")
		WWW = Data("WWW")
		AibangId = Data("AibangId")
		'����poi��
		strsqlcmd = "INSERT INTO poi(AibangID,City,Name,Phone,Address,Web) VALUES('"+AibangId+"','"+City+"','"+Name+"','"+Phone+"','"+Address+"','"+WWW+"')"
		Try	
			IsExist = False	
			cmd = New OleDbCommand(strsqlcmd, cn)
			cmd.ExecuteNonQuery()
		Catch ex As System.Data.OleDb.OleDbException
			Log.Info("����poi�����ظ�ֵ:"+City+" "+Name)
			IsExist = True
		Catch ex As Exception
			Log.Error("����poi���쳣����:", ex)
			IsExist = True
		End Try
		
		'����seed����seed��, ��ԭʼpoiԽԶ��������Խ�ߵļ�����Ϊseed		
		If IsExist = False And rnd.NextDouble() < (i/Count)/3 Then
			strsqlcmd = "INSERT INTO seed(city, poi, category, isused, isfinished, lasttime) VALUES('"+City+"','"+Name+"','"+Category+"',0,0,Now())"
			Try		
				cmd = New OleDbCommand(strsqlcmd, cn)
				cmd.ExecuteNonQuery()
				Log.Info("����������:"+City+"-"+Name+"-"+Category)
			Catch ex As System.Data.OleDb.OleDbException
				Log.Info("����seed�����ظ�ֵ:"+City+" "+Name)
			Catch ex As Exception
				Log.Error("����seed���쳣����:", ex)
			End Try
		End If
		i = i + 1
	Next
	
	'����seed����
	Try
		cmd = New OleDbCommand("UPDATE [seed] SET [isused]=1,[isfinished]=1, [lasttime]=Now() WHERE [city] = '"+City+"' AND [Poi] = '"+Poi+"' AND [Category] = '"+Category+"'", cn)
		cmd.ExecuteNonQuery()
	Catch ex As Exception
		Log.Error("����seed���쳣:", ex)
	End Try
	'����ϵͳ����������
	Task.TaskGenerateNewTask()
Catch ex As Exception
	Log.Error("��db����:", ex)
Finally	
	cn.Close()
End Try


'===== Scirpt End ======