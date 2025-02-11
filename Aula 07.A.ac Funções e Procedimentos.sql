/*
Questão 01. Crie um procedimento chamado student_grade_points segundo os critérios abaixo:
a. Utilize como parâmetro de entrada o conceito. Exemplo: A+, A-, ...
b. Retorne os atributos das tuplas: Nome do estudante, Departamento do estudante, Título do curso, Departamento do curso, Semestre do curso, Ano do curso, Pontuação alfanumérica, Pontuação numérica.
c. Filtre as tuplas utilizando o parâmetro de entrada.
*/
-- Criação do procedimento
CREATE PROCEDURE dbo.student_grade_points @grade varchar(20)
AS
    SET NOCOUNT ON; -- Desativa as mensagens que o SQL Server envia ao cliente após a execução de qualquer instrução
    SELECT student.name, student.dept_name AS student_dept, course.title, course.dept_name AS course_dept, [section].semester, [section].[year], takes.grade, grade_points.points   
	FROM (((student JOIN takes ON student.ID  = takes.ID) 
	JOIN [section] ON takes.course_id = [section].course_id AND takes.sec_id = [section].sec_id AND takes.semester = [section].semester AND 
                  takes.[year] = [section].[year])
	JOIN course ON [section].course_id = course.course_id)
	JOIN grade_points ON takes.grade = grade_points.grade 
	WHERE takes.grade = @grade
    ORDER BY student.name, student.dept_name;


-- Execução do procedimento
EXEC dbo.student_grade_points 'B';

-- Eliminar procedimento
DROP PROCEDURE dbo.student_grade_points;


/*
Questão 02.
Crie uma função chamada return_instructor_location segundo os critérios abaixo:
a. Utilize como parâmetro de entrada o nome do instrutor.
b. Retorne os atributos das tuplas: Nome do instrutor, Curso ministrado, Semestre do curso, Ano do curso, prédio e número da sala na qual o curso foi ministrado
c. Exemplo: SELECT * FROM dbo.return_instructor_location('Gustafsson'); 
 */
CREATE FUNCTION dbo.return_instructor_location (@instructor_name char(20))
RETURNS TABLE  
AS
RETURN (SELECT instructor.name, course.title, [section].semester, [section].[year], [section].building, [section].room_number
FROM ((dbo.instructor JOIN dbo.teaches ON instructor.ID = teaches.ID)
JOIN dbo.[section] ON teaches.course_id = [section].course_id AND teaches.sec_id = [section].sec_id AND 
                      teaches.semester = [section].semester AND teaches.[year] = [section].[year])
JOIN dbo.course ON [section].course_id  = course.course_id
WHERE instructor.name = @instructor_name);

-- Execução da função
SELECT * FROM dbo.return_instructor_location('Gustafsson')